@lazyglobal off.

lib:export(lex(
  "execute", execute@
)).

local stts is lib:import("stats").
local math is lib:import("math").
local tpt is lib:import("output").

// Executes the next manoeuver node
local function execute {
  if (not hasnode) {
    print "Cowardly refusing to execute a non-existing node.".
    return.
  }.

  local dV is nextnode:deltav:mag.
  local halfDv is dV / 2.
  local preBurn is math:calcBurnTime(halfDv).

  // nextnode:time doesn't work, using `time + nextnode:eta` instead.
  //local burnStartTime is nextnode:time - preBurn:burnTime.
  local burnStartTime is time + nextnode:eta - preBurn:burnTime.

  sas off.

  lock steering to lookdirup(nextnode:deltav, ship:facing * v(0, 1, 0)).

  lock burnStart to burnStartTime:seconds - time:seconds.

  clearscreen.
  tpt:pushCursorDown(8).

  until burnStart <= 0 {
    printStats().
    wait 0.0001.
  }.

  lock remainingBurnTime to math:calcBurnTime():burnTime.

  lock throttle to max(min(remainingBurnTime, 1), 0.01).

  until remainingBurnTime < 0.001 or
    vang(ship:facing:vector, nextnode:deltav) > 90 {

    printStats().
    wait 0.0001.
  }.


  lock throttle to 0.
  set ship:control:pilotmainthrottle to 0.
  set steering to ship:facing.
  unlock throttle.
  unlock steering.
  sas on.
  printStats().
  unlock burnStart.
  print "Done!" at(0, 6).
}.

local function printStats {
    print tpt:fulll(tpt:format("Time to burn:", 14) +
      tpt:format(burnStart, 10, 3)) at(0, 2).
    print tpt:fulll(tpt:format("delta-V:", 14) +
      tpt:format(nextnode:deltav:mag, 10, 3)) at(0, 3).
    print tpt:fulll(tpt:format("Throttle:", 14) +
      tpt:format(throttle, 10, 3)) at(0, 4).
}.
