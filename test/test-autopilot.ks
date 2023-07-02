@lazyglobal off.

runoncepath("/libs/libs.ks").

local aero is lib:import("aero").
local output is lib:import("output").
local math is lib:import("math").

lib:execute(main@).

local function main {
  aero:setAltitude(2000).

  sas off.

  local stop is false.
  local reading is false.
  local mode is "".
  local input is "".
  local prompt is "".

  local PROMPT_LINE is 8.

  clearscreen.

  reset().

  until brakes or stop {
    set ship:control:pitch to aero:maintainAltitude().
    set ship:control:roll to aero:maintainLevel().

    aero:printStats("altitude", 0).
    aero:printStats("roll", 5).

    print output:fulll(output:format(math:compassHeading(), 7, 2)) at (0, 11).

    if terminal:input:haschar {
      local inputChar is terminal:input:getchar:tolower.

      if reading {
        if inputChar = terminal:input:enter {
          local num is input:toscalar(-1001).

          if num = -1001 {
            showPrompt("`" + num + "` is not a valid number.").
            reset().
          } else if mode = "a" {
            aero:setAltitude(num).
            reset().
            showPrompt("Altitude set to: " + num).
          } else {
            aero:setLevel(num).
            reset().
            showPrompt("Roll set to: " + num).
          }.
        } else if inputChar = terminal:input:backspace {
          set input to input:substring(0, input:length - 1).
          showPrompt().
        } else {
          set input to input + inputChar.
          showPrompt().
        }.
      } else {
        if inputChar = "b" {
          set stop to true.
          reset().
        } else if inputChar = "a" {
          setup("Enter new altitude: ").
          set mode to "a".
        } else if inputChar = "r" {
          setup("Enter new level: ").
          set mode to "r".
        }.
      }.
    }.

    wait 0.001.
  }.

  set ship:control:neutralize to true.

  local function setup {
    local parameter newPrompt.

    set prompt to newPrompt.
    set input to "".
    set reading to true.
    showPrompt().
  }.

  local function reset {
    set prompt to "Press 'b' (or brakes) to quit, 'a' to change altitude" +
      " or 'r' change roll angle.".
    set input to "".
    set reading to false.
    showPrompt().
  }.

  local function showPrompt {
    local parameter text is prompt + input.

    print output:format(text, terminal:width) at (0, PROMPT_LINE).
    print output:format(" ", terminal:width) at (0, PROMPT_LINE + 1).
    // ^ clear the line below too
  }.
}.
