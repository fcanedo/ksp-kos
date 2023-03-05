@lazyglobal off.

export(lex(
  "setAltitude", setAltitude@,
  "maintainAltitude", maintainAltitude@,
  "setLevel", setLevel@,
  "maintainLevel", maintainLevel@,
  "getStats", getStats@,
  "printStats", printStats@
)).

local math is import("math").
local output is import("output").

// contains the PIDs required for maintaining altitude
local altitudePIDs is lexicon(
  // Sets the desired vertical velocity to get to and maintain the
  // desired altitude.
  "verticalVelocity", lexicon(
    "pid", pidloop(1.0, 0.0, 0.0, -50, 50),
    "par", "altitude"
  ),

  // Sets the desired pitch to get to and maintain the desired
  // vertical velocity as determined by verticalVelocity:pid.
  // Max pitch angle is 45 degrees either way, to avoid climbing or
  // descending too steeply.
  "pitch", lexicon(
    "pid", pidloop(1.0, 0.0, 0.0, -45, 45),
    "par", "v. velocity"
  ),

  // Sets the desired torque rate to get to and maintain the desired
  // pitch angle as determined by pitch:pid.
  "torque", lexicon(
    "pid", pidloop(1.0, 0.0, 0.0, -100, 100),
    "par", "pitch"
  ),

  // Sets the desired elevator input to get to and maintain the desired
  // rotation rate as determined by torque:pid.
  "elevator", lexicon(
    "pid", pidloop(0.01, 0.0, 0.0, -1, 1),
    "par", "torque"
  )
).

// default altitude if not set with setAltitude
set altitudePIDs:verticalVelocity:setpoint to 2000.

local rollPIDs is lexicon(
  "torque", lexicon(
    "pid", pidloop(1.0, 0.0, 0.0, -10, 10),
    "par", "roll"
  ),
  "roll", lexicon(
    "pid", pidloop(0.01, 0.0, 0.0, -1, 1),
    "par", "torque"
  )
).

// we like to fly level
set rollPIDs:torque:setpoint to 0.

local headingPIDs is lexicon(

).
local function setAltitude {
  local parameter newAltitude.

  set altitudePIDs:verticalVelocity:pid:setpoint to newAltitude.
}.

// Returns the elevator input needed to get to and maintain
// the desired altitude. Needs to be called continuously.
// Call setAltitude to set the desired altitude.
local function maintainAltitude {
  local targetVVelocity is
    altitudePIDs:verticalVelocity:pid:update(time:seconds, ship:altitude).

  set altitudePIDs:pitch:pid:setpoint to targetVVelocity.
  local targetPitch is altitudePIDs:pitch:pid:update(time:seconds, ship:verticalspeed).

  set altitudePIDs:torque:pid:setpoint to targetPitch.
  local targetTorque is altitudePIDs:torque:pid:update(time:seconds, math:getPitch()).

  set altitudePIDs:elevator:pid:setpoint to targetTorque.
  return altitudePIDs:elevator:pid:update(time:seconds, math:torqueOf("pitch")).
}.

local function setLevel {
  local parameter newLevel.

  set rollPIDs:torque:pid:setpoint to newLevel.
}.

local function maintainLevel {
  local targetRoll is rollPIDs:torque:pid:update(time:seconds, math:getRoll()).

  set rollPIDs:roll:pid:setpoint to targetRoll.
  return rollPIDs:roll:pid:update(time:seconds, math:torqueOf("roll")).
}.

local function getStats {
  local parameter controlSet is "altitude".

  local pidSet is lexicon().

  if controlSet = "altitude" {
    set pidSet to altitudePIDs.
  } else {
    set pidSet to rollPIDs.
  }.

  local result is list().

  for key in pidSet:keys {
    result:add(lexicon(
      "par", pidSet[key]:par, // name of the parameter under control
      "input", pidSet[key]:pid:input, // the last measured value
      "setpoint", pidSet[key]:pid:setpoint, // the desired value
      "output", pidSet[key]:pid:output // the control input
    )).
  }.

  return result.
}.

local function printStats {
  local parameter controlSet is "altitude".
  local parameter start is -1.

  local i is 0.

  for stat in getStats(controlSet) {
    local prcsn is choose 2 if stat:setpoint < 1000 else 0.
    local line is output:format(stat:par, 12) +
      "| target: " + output:format(stat:setpoint, 6, prcsn) +
      ", actual: " + output:format(stat:input, 6, prcsn).

    if start > -1
      print output:format(line, terminal:width) at(0, start + i).
    else
      print line.

    set i to i + 1.
  }.
}.

local function getPitch {
  return 90 - vectorangle(ship:up:forevector, ship:facing:forevector).
}.

local function getRoll {
  local trig_x is vdot(ship:facing:topvector, ship:up:vector).
  local vec_y is vcrs(ship:up:vector, ship:facing:forevector).
  local trig_y is vdot(ship:facing:topvector, vec_y).
  return arctan2(trig_y, trig_x).
}.
