@lazyglobal off.

wait until ship:unpacked.

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

local bootFilePath is path("1:/"):combine(core:bootfilename).

if scriptpath() = bootFilePath and
    core:volume = path():volume {

  compile "0:/libs/libs.ks" to "1:/libs/libs.ksm".
  runoncepath("1:/libs/libs.ksm").

  lib:init().

  deletepath(bootFilePath).
  set core:bootfilename to "".
  deletepath(path("1:/"):combine("/boot")).

  print "System initialized.".
} else {
  print "This is a boot script. Don't run manually.".
}.
