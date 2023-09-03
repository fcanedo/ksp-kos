@lazyglobal off.

lib:export(lex(
  "format", format@,
  "fulll", fulll@,
  "pushCursorDown", pushCursorDown@
)).

// there is no way to create a string with a character repeated x times
// this allows us to take a substring of x zeros,
// which prevents us from looping in time-sensitive code
local initZeros is {
  local i is 0.
  local s is "".

  until i >= terminal:width * 10 {
    set s to s + "00000".
    set i to i + 5.
  }.

  return s.
}.

local bagOfZeros is initZeros().

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

  local pointLoc is data:findlast(".").
  local missingZeros is precision - (choose data:length - pointLoc - 1
    if pointLoc > -1 else 0).
  local decimalPoint is choose "" if pointLoc > 0 else ".".

  return data + decimalPoint + bagOfZeros:substring(1, missingZeros).
}.

local function pushCursorDown {
  local parameter lines.

  from { local i is lines. } until i <= 0 step {set i to i - 1. } do {
    print " ".
  }.
}.
