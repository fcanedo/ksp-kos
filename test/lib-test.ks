@lazyglobal off.

{
  export(lex(
    "sayHello", sayHello@
  )).

  local function sayHello {
    print "Hello, Kerbin!".
  }
}
