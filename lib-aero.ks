@lazyglobal off.

export(lex(
  "setAltitude", setAltitude@,
  "maintainAltitude", maintainAltitude@,
  "displayStats", displayStats@,
  "step", step@
)).

// Sets the desired vertical velocity to get to and maintain the
// desired altitude. No min or max output, relying on max/min pitch angle.
local verticalVelocityPid is pidloop(1.0, 0.0, 0.0, -50, 50).
set verticalVelocityPid:setpoint to 2000.

// Sets the desired pitch to get to and maintain the desired
// vertical velocity as determined by verticalVelocityPid.
// Max pitch angle is 30 degrees either way, to avoid climbing or
// descending too steeply.
local pitchPid is pidloop(1.0, 0.0, 0.0, -30, 30).

// Sets the desired torque rate to get to and maintain the desired
// pitch angle as determined by pitchPid.
local torquePid is pidloop(1.0, 0.0, 0.0, -100, 100).

// Sets the desired elevator input to get to and maintain the desired
// rotation rate as determined by torquePid.
local elevatorPid is pidloop(0.01, 0.0, 0.0, -1, 1).

// Remove after testing
local elevatorInput is 0.

local function setAltitude {
  local parameter newAltitude.

  set verticalVelocityPid:setpoint to newAltitude.
}.

local function step {
  local parameter mode.
  local parameter direction.
  local pid is "".

  if mode = "v" set pid to verticalVelocityPid.
  if mode = "p" set pid to pitchPid.
  if mode = "t" set pid to torquePid.
  if mode = "e" set pid to elevatorPid.

  if direction = "u" set pid:kp to pid:kp + 0.1.
  if direction = "d" set pid:kp to pid:kp - 0.1.
}.

// Returns the elevator input needed to get to and maintain
// the desired altitude. Needs to be called continuously.
// Call setAltitude to set the desired altitude.
local function maintainAltitude {
  local verticalVelocity is
    verticalVelocityPid:update(time:seconds, ship:altitude).

  set pitchPid:setpoint to verticalVelocity.
  local pitch is pitchPid:update(time:seconds, ship:verticalspeed).

  set torquePid:setpoint to pitch.
  local torque is torquePid:update(time:seconds, torqueOf("pitch")).

  set elevatorPid:setpoint to torque.
  set elevatorInput to elevatorPid:update(time:seconds, getPitch()).
  return elevatorInput.
}.

// local function maintainAltitude {
//   local parameter altitude is verticalVelocityPid:setpoint.
// 
//   set verticalVelocityPid:setpoint to altitude.
// 
//   lock pitchPid:setpoint to
//     verticalVelocityPid:update(time:seconds, ship:altitude).
// 
//   lock elevatorPid:setpoint to
//     pitchPid:update(time:seconds, ship:verticalspeed).
// 
//   lock ship:control:pitch to elevatorPid:update(time:seconds, getPitch).
// }.

local function getPitch {
  return 90 - vectorangle(ship:up:forevector, ship:facing:forevector).
}.

local function displayStats {
  clearscreen.
  print "Desired altitude: " + verticalVelocityPid:setpoint.
  print "Actual altitude: " + ship:altitude.
  print "Desired vertical speed: " + pitchPid:setpoint.
  print "Actual vertical speed: " + ship:verticalspeed.
  print "Desired pitch: " + torquePid:setpoint.
  print "Actual pitch: " + getPitch().
  print "Desired torque: " + elevatorPid:setpoint.
  print "Actual torque: " + torqueOf("pitch").
  print "Desired elevator input: " + elevatorInput.
  print "Elevator input: " + ship:control:pitch.
  print "Vertical speed Kp: " + verticalVelocityPid:Kp.
  print "Vertical speed Ki: " + verticalVelocityPid:Ki.
  print "Vertical speed Kd: " + verticalVelocityPid:Kd.
  print "Pitch Kp: " + pitchPid:Kp.
  print "Pitch Ki: " + pitchPid:Ki.
  print "Pitch Kd: " + pitchPid:Kd.
  print "Rotation Kp: " + pitchPid:Kp.
  print "Rotation Ki: " + pitchPid:Ki.
  print "Rotation Kd: " + pitchPid:Kd.
  print "Elevator Kp: " + elevatorPid:Kp.
  print "Elevator Ki: " + elevatorPid:Ki.
  print "Elevator Kd: " + elevatorPid:Kd.
}.

local function axisTorque {
  local parameter axis. // Vector of the axis of interest.

  // The dotproduct of angular momentum and the axis
  // gives the rate of rotation along the axis
  return vdot(axis, ship:angularvel).
}.

local function torqueOf {
  local parameter steering. // "pitch", "yaw" or "roll"

  if steering = "pitch" return axisTorque(ship:facing * v(1, 0, 0)).
  if steering = "yaw" return axisTorque(ship:facing * v(0, 1, 0)).
  if steering = "roll" return axisTorque(ship:facing * v(0, 0, 1)).
}.
