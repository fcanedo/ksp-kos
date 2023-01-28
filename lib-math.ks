@lazyglobal off.

export(lex(
  "axisTorque", axisTorque@,
  "torqueOf", torqueOf@
)).

// Returns the torque (rate of rotation) along the desired axis.
local function axisTorque {
  local parameter axis. // Vector of the axis of interest.

  // The dotproduct of angular momentum and the axis
  // gives the rate of rotation along the axis
  return vdot(axis, ship:angularvel).
}.

// Returns the torque (rate of rotation) along one of the major axis,
// as specified.
local function torqueOf {
  local parameter steering. // "pitch", "yaw" or "roll"

  if steering = "pitch" return axisTorque(ship:facing * v(1, 0, 0)).
  if steering = "yaw" return axisTorque(ship:facing * v(0, 1, 0)).
  if steering = "roll" return axisTorque(ship:facing * v(0, 0, 1)).
}.
