@lazyglobal off.

local parameter apsis is "".

runoncepath("libs/libs").

local mnvrs is lib:import("manoeuvres").

lib:execute(main@).

local function main {
  mnvrs:circularizeAt(apsis).
}.
