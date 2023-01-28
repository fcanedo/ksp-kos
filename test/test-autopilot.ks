@lazyglobal off.

runoncepath("0:libs.ks").

local aero is import("aero", "", false).

aero:setAltitude(2000).

sas off.

local stop is false.
local mode is "v".

until brakes or stop {
  set ship:control:pitch to aero:maintainAltitude().
  aero:displayStats().

  if terminal:input:haschar {
    local char is terminal:input:getchar:tolower.

    if char = "v" or char = "p" or char = "e" or char = "t" set mode to char.

    if char = "u" or char = "d" aero:step(mode, char).

    if char = "b" set stop to true.
  }.
}.

set ship:control:neutralize to true.
