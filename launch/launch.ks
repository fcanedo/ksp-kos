@lazyglobal off.


runoncepath("0:/libs/libs.ks").

local mnvrs is lib:import("manoeuvres").

lib:execute(main@).

local function main {
  local altitudeHorizontal is 50.
  local targetApoapsis is 100.
  local parameter inclination is 0.
  local parameter direction is mod(inclination + 90, 180).

  if ship:status = "PRELAUNCH" {
    local done is false.

    sas off.
    rcs off.

    lock steering to ship:facing.
    lock throttle to 1.

    clearscreen.

    print "Ready to launch. Press a key in the terminal or stage.".

    local launch is false.

    on stage:number {
      lock throttle to 1.
      set launch to true.
    }.

    on terminal:input:haschar {
      terminal:input:getchar.
      lock throttle to 1.
      stage.
      set launch to true.
    }.

    wait until launch.

    when mustStage() and not done then {
      stage.
      wait 0.1.

      return not done.
    }.
    
    lock steering to calcHeading(direction, altitudeHorizontal).

    wait until ship:orbit:apoapsis >= targetApoapsis * 1000.

    lock throttle to 0.
    lock steering to lookdirup(ship:prograde:vector, ship:body:position).

    mnvrs:circularizeAt("a").

    if (ship:body:atm:exists)
      wait until ship:altitude >= ship:body:atm:height.

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
    local pitch is max(0, -(90 / (altitudeHorizontal * 1000)) * ship:altitude + 90).
    return heading(direction, pitch, 180).
  }.
}.

local function mustStage {
  for engine in ship:engines {
    if engine:ignition and engine:flameout
      return true.
  }.

  return false.
}.
