@lazyglobal off.

wait until ship:unpacked.

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

local bootFilePath is path("1:/"):combine(core:bootfilename).

if scriptpath() = bootFilePath and
    core:volume = path():volume {

  compile "0:/libs/libs.ks" to "1:/libs/libs.ksm".
  runoncepath("1:/libs/libs.ksm").

  lib:init().

  local lnch is lib:import("launch", true).

  lnch:launch(0, list(
      lex(
        "twr", 1.8,
        "from", 0 * 1000),
      lex(
        "twr", 1.3,
        "from", 20 * 1000),
      lex(
        "twr", 0.9,
        "from", 50 * 1000)
    )
  ).

  // We're not going to launch again.
  lib:deleteLib("launch").

  set core:bootfilename to "".
  core:volume:delete("/boot").
} else {
  print "This is a boot script. Don't run manually.".
}.
