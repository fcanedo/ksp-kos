@lazyglobal off.

local parameter apsis is "".

runoncepath("libs/libs").

lib:execute(main@).

local function main {
  if apsis:startswith("a")
    addNode(body:radius + orbit:apoapsis, time + eta:apoapsis).
  else if apsis:startswith("p")
    addNode(body:radius + orbit:periapsis, time + eta:periapsis).
  else {
    print "Parameter a[poapsis] or p[eriapsis] required.".
    return.
  }.
}.

local function addNode {
  local parameter apsisRadius.
  local parameter apsisTime.

  local velocityAt is sqrt(
    velocity:orbit:mag^2 - 2 * body:mu *
      (1 / (body:radius + altitude) - 1 / apsisRadius)
    ).
  local circularVelocity is sqrt(body:mu / apsisRadius).

  add node(apsisTime, 0, 0, circularVelocity - velocityAt).
}.
