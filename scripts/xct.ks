@lazyglobal off.

runoncepath("libs").

local mnvrs is import("manoeuvres").

execute(main@).

local function main {
  if hasnode and nextnode:time > (time + 60) {
    mnvrs:execute().
  } else {
    print "There hast to be at least one node and it has to be at least " +
      "60 seconds away.".
  }.
}.
