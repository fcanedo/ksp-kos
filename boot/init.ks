@lazyglobal off.

wait until ship:unpacked.

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

local bootFilePath is path("1:/"):combine(core:bootfilename).

if scriptpath() = bootFilePath and
    core:volume = path():volume {

  deletepath(bootFilePath).
  set core:bootfilename to "".
  deletepath(path("1:/"):combine("/boot")).

  compile "0:/libs.ks" to "1:/libs.ksm".
  runoncepath("1:/libs.ksm").

  setInit().

  local scripts is archive:files:scripts:list:values.

  for script in scripts {
    local remotePath is path("0:/scripts"):combine(script:name).
    local localPath is path("1:/"):combine(script:name):changeextension("ksm").

    compile remotePath to localPath.
    runpath(localPath).
  }.

  print "System initialized.".
} else {
  print "This is a boot script. Don't run manually.".
}.
