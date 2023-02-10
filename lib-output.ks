@lazyglobal off.

export(lex(
  "format", format@
)).

global function format {
  local parameter data.
  local parameter width is 0.
  local parameter precision is 0.

  if data:istype("String") {
    return data:padright(width).
  } else if data:istype("Scalar") {
    local num is round(data, precision).

    return num:tostring:padleft(width).
  } else {
    return data:tostring:padleft(width).
  }.
}.
