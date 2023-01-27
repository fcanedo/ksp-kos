@lazyglobal off.

compile "0:/libs.ks" to "1:/libs.ksm".
runoncepath("1:/libs.ksm").

local tst is import("test", "test").

tst:sayHello().
