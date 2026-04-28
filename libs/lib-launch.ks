@lazyglobal off.

lib:export(lex(
  "launch", launch@
)).

local mnvrs is lib:import("manoeuvres").

local function launch {
  local parameter inclination is 0.
  local parameter legs is list().

  local altitudeHorizontal is 60 * 1000. // meter.
  local targetApoapsis is 100 * 1000. // meter.
  local direction is mod(inclination + 90, 180).

  if ship:status = "PRELAUNCH" {
    local done is false.

    sas off.
    rcs off.

    lock steering to ship:facing.

    clearscreen.

    lock throttle to 1.
    for leg in legs {
      local from is leg:from.
      local twr is leg:twr.

      if ship:altitude < from
        on (ship:altitude > from) {
          lock throttle to calcThrottle(twr).
        }.
      else
        lock throttle to calcThrottle(twr).
    }.

    local weight is ship:body:mu * ship:mass /
      (ship:body:radius)^2.

    print "Ready to launch. Press a key in the terminal or stage.".

    on terminal:input:haschar {
      terminal:input:getchar.
      stage.
    }.

    when mustStage() and not done then {
      stage.
      wait 0.001.

      return not done.
    }.

    lock steering to calcHeading(direction, altitudeHorizontal).

    wait until ship:orbit:apoapsis >= targetApoapsis.

    lock throttle to 0.
    lock steering to progradeDirection.

    if (ship:body:atm:exists)
      wait until ship:altitude >= ship:body:atm:height.

    mnvrs:circularizeAt("apoapsis").
    mnvrs:execute().

    set done to true.

    lock throttle to 0.
    set ship:control:pilotmainthrottle to 0.
    lock steering to ship:facing.
    unlock throttle.
    unlock steering.
    sas on.

    deletepath("1:/launch.ks").
  } else {
    print "Ship is not on the pad.".
  }.
}.

local function calcHeading {
  local parameter direction.
  local parameter altitudeHorizontal.

  if ship:velocity:surface:mag < 30 {
    return ship:facing.
  } else {
    local pitch is max(0, -(90 / (altitudeHorizontal)) * ship:altitude + 90).
    return heading(direction, pitch, 180).
  }.
}.

local function calcThrottle {
  local parameter wantedTwr.
  local parameter engines is ship:engines.

  local lockedThrust is 0.
  local throttlableThrust is 0.

  for engine in engines {
    if engine:ignition {
      if engine:throttlelock
        set lockedThrust to lockedThrust + engine:availablethrust.
      else
        set throttlableThrust to throttlableThrust + engine:availablethrust.
    }
  }.

  local weight is ship:body:mu * ship:mass / ship:body:radius^2.

  local wantedThrust is wantedTwr * weight.

  if wantedThrust <= lockedThrust
    return 0.
  else if wantedThrust > lockedThrust + throttlableThrust
    return 1.
  else
    return (wantedThrust - lockedThrust) / throttlableThrust.
}.

local function mustStage {
  for engine in ship:engines {
    if engine:ignition and engine:flameout
      return true.
  }.

  return false.
}.

local function progradeDirection {
  return lookdirup(ship:prograde:vector, ship:body:position).
}.
