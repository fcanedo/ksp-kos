@lazyglobal off.

lib:export(lex(
  "getIsp", getIsp@
)).

local function getIsp {
  local totalIsp is 0.
  local allEngines is list().
  list engines in allEngines.

  local avThrust is ship:availablethrust.

  if avThrust <= 0 // we're staging, no thrust
    return -1.

  for engine in allEngines {
    set totalIsp to totalIsp + engine:availablethrust /
      avThrust * engine:isp.
  }.

  return totalIsp.
}.

