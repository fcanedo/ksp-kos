@lazyglobal off.

compile "0:/libs.ks" to "1:/libs.ksm".
runoncepath("1:/libs.ksm").

local math is import("math").

print math:torqueOf("pitch").
print math:torqueOf("yaw").
print math:torqueOf("roll").
