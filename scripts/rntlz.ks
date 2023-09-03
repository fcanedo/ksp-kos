@lazyglobal off.

local parameter confirm is false.
local parameter debug is false.

// Can't define functions here, it breaks compilation
// Possibly due to https://github.com/KSP-KOS/KOS/issues/691

// Only do something if we're running on the local volume
// and we have confirmation.
if confirm and scriptpath():volume = core:volume {
  if homeconnection:isconnected {
    // remove libs
    for item in core:volume:files:libs:lex:values {
      if item:isfile and (item:extension = "ks" or item:extension = "ksm")
        core:volume:delete(path(item):segments:join("/")).
    }.

    // remove scripts
    for item in core:volume:root:lex:values {
      if item:isfile and (item:extension = "ks" or item:extension = "ksm")
        core:volume:delete(path(item):segments:join("/")).
    }.

    // re-init
    compile "0:/libs/libs.ks" to "1:/libs/libs.ksm".
    runoncepath("libs/libs").

    if debug
      lib:initDebug().
    else
      lib:init().

    print "Re-initialized scripts and libraries.".
  } else {
    print "No connection to the Space Center. Can't reinitialize right now.".
  }.
}.
