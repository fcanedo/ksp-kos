@lazyglobal off.

wait until ship:unpacked.

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

local bootFilePath is path("1:/"):combine(core:bootfilename).

if scriptpath() = bootFilePath and
    core:volume = path():volume {

  copypath("0:/libs.ks", "1:/libs.ks").
  runoncepath("libs").

  lib:init(true).

  print "System initialized.".
} else {
  print "This is a boot script. Don't run manually.".
}.
