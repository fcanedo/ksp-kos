@lazyglobal off.

compile "0:/libs.ks" to "1:/libs.ksm".

runoncepath("1:/libs.ksm").

local output is import("output").

if output:format("Hello", 6) = "Hello " {
  print "V".
} else {
  print "x".
}.

if  output:format(6.1234, 5, 2) = " 6.12" {
  print "V".
} else {
  print "x".
}.

if  output:format(6.1254, 5, 2) = " 6.13" {
  print "V".
} else {
  print "x".
}.

