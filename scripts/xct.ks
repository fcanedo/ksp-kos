@lazyglobal off.

runoncepath("libs").

local mnvrs is lib:import("manoeuvres").

lib:execute(main@).

local function main {
  mnvrs:execute().
}.
