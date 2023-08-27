@lazyglobal off.

lib:export(lex(
  "getIsp", getIsp@
)).

local function getIsp {
  local totalIsp is 0.
  local allEngines is list().
  list engines in allEngines.

  if ship:availablethrust <= 0 // we're staging, no thrust
    return 0.

  for engine in allEngines {
    set totalIsp to totalIsp + engine:availablethrust /
      ship:availablethrust * engine:isp.
  }.

  return totalIsp.
}.

