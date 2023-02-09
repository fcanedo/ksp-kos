@lazyglobal off.

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

switch to 0.

local es is "".
list engines in es.

for e in es {
  writeStats(e).
}.

print "Done!".

local function writeStats {
  local parameter engine.
  local logName is engine:name + ".csv".

  log engine:title to logName.
  log "pressure, isp" to logName.


  from { local i is 0. } until i > 100 step { set i to i + 1. } do {
    local f is i / 100.
    log f + ", " + engine:ispat(f) to logName.
  }.
}.
