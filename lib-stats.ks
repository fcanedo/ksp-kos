@lazyglobal off.

lib:export(lex(
  "getIsp", getIsp@
)).

local function getIsp {
  local totalIsp is 0.
  local allEngines is list().
  list engines in allEngines.

  for engine in allEngines {
    set totalIsp to totalIsp + engine:availablethrust /
      ship:availablethrust * engine:isp.
  }.

  return totalIsp.
}.

