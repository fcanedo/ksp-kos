@lazyglobal off.

lib:export(lex(
  "format", format@,
  "fulll", fulll@,
  "pushCursorDown", pushCursorDown@
)).

local function format {
  local parameter data.
  local parameter width is 0.
  local parameter precision is 0.

  if data:istype("String") {
    return data:padright(width).
  } else if data:istype("Scalar") {
    local num is addTrailingZeros(round(data, precision):tostring, precision).

    return num:padleft(width).
  } else {
    return data:tostring:padleft(width).
  }.
}.

local function fulll {
  local parameter data is " ".

  return format(data, terminal:width).
}.

local function addTrailingZeros {
  local parameter data.
  local parameter precision.

  local result is data.
  local pointLoc is data:findlast(".").
  local zeros is choose data:length - pointLoc if pointLoc > -1 else 0.

  from {
    local i is zeros.
  } until i >= 4 step {
    set i to i + 1.
  } do {
    set result to result + (choose "." if i = 0 else "0").
  }.

  return result.
}.

local function pushCursorDown {
  local parameter lines.

  from { local i is lines. } until i <= 0 step {set i to i - 1. } do {
    print " ".
  }.
}.
