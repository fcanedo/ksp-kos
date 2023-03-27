@lazyglobal off.

lib:export(lex(
  "axisTorque", axisTorque@,
  "torqueOf", torqueOf@,
  "calcBurnTime", calcBurnTime@,
  "compassHeading", compassHeading@,
  "getPitch", getPitch@,
  "getRoll", getRoll@
)).

local stts is lib:import("stats").

// Returns the torque (rate of rotation) along the desired axis.
local function axisTorque {
  local parameter axis. // Vector of the axis of interest.

  // The dotproduct of angular momentum and the axis
  // gives the rate of rotation along the axis
  return vdot(axis, ship:angularmomentum).
}.

// Returns the torque along one of the major axis,
// as specified.
local function torqueOf {
  local parameter steering. // "pitch", "yaw" or "roll"

  if steering = "pitch" return axisTorque(ship:facing * v(1, 0, 0)).
  if steering = "yaw" return axisTorque(ship:facing * v(0, 1, 0)).
  if steering = "roll" return axisTorque(ship:facing * v(0, 0, 1)).
}.

// Calculates the burn time of a manoeuvre and final mass of the vessel
//  after performing the manoeuvre.
// Parameters:
//  dV: the magnitude (m/s) of the manoeuvre,
//    defaults to the delta-V of the next manoeuvre node
//  startingMass: the mass of the vessel at the start of the manoeuvre,
//    defaults to the current mass of the current vessel.
//  isp: the specific impulse of the vessel,
//    defaults to the current vessel's specific impulse
// Returns: a lexicon containing the "burnTime" and "endMass" of
//  the manoeuvre.
local function calcBurnTime {
  local parameter dV is choose nextnode:deltav:mag if hasnode else 0.
  local parameter startingMass is ship:mass.
  local parameter isp is stts:getIsp().

  if (dV <= 0) return 0.

  local ve is isp * constant:g0. // The effective exhaust velocity.
  local propFrac is constant:e^(-dV / ve). // The propellant mass fraction.

  return lex(
    "burnTime", startingMass * ve * (1 - propFrac) /
      ship:availablethrust,
    "endMass", startingMass * propFrac
  ).
}.

local function compassHeading {
  local east is vcrs(ship:up:vector, ship:north:vector).
  local trig_x is vdot(ship:north:vector, ship:facing:forevector).
  local trig_y is vdot(east, ship:facing:forevector).

  local result is arctan2(trig_y, trig_x).

  if result < 0
    return 360 + result.
  else
    return result.
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
