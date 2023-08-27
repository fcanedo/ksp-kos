@lazyglobal off.

runoncepath("libs/libs").

local mnvrs is lib:import("manoeuvres").

lib:execute(main@).


local function main {
  local parameter inclination is 0.
  local parameter direction is mod(inclination + 90, 180).
  local parameter legs is list(
    lex(
      "twr", 1.8,
      "from", 0 * 1000),
    lex(
      "twr", 1.3,
      "from", 20 * 1000),
    lex(
      "twr", 0.9,
      "from", 50 * 1000)
  ).

  local altitudeHorizontal is 70 * 1000. // meter.
  local altitudePrograde is 35 * 1000. // meter.
  local targetApoapsis is 100 * 1000. // meter.

  if ship:status = "PRELAUNCH" {
    local done is false.

    sas off.
    rcs off.

    lock steering to ship:facing.

    clearscreen.

    for leg in legs {
      local from is leg:from.
      local twr is leg:twr.
      on (ship:altitude > from) {
        lock throttle to calcThrottle(twr).
      }.
    }.

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

    wait until ship:altitude >= altitudePrograde or
      ship:orbit:apoapsis >= targetApoapsis.

    lock steering to progradeDirection.

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

  if wantedTWR <= 0 or
    ship:availablethrust <= 0 // we're about to stage or we're on the pad
    return 1.
  else {
    local weight is ship:body:mu / ship:body:radius^2 * ship:mass.
    local availableTWR is ship:availablethrust / weight.

    return wantedTWR / availableTWR.
  }.
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
