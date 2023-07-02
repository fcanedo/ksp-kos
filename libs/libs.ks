@lazyglobal off.

global lib is lexicon(
  "init", init@,
  "import", import@,
  "export", export@,
  "execute", execute@
).

local data is lexicon(
 "libs", lexicon(),
 "libNames", stack(),
 "init", false,
 "debug", false
).

local function execute {
  local parameter main.

  if not data:init
    main().
}.

local function init {
  local parameter debug is false.

  set data:debug to debug.
  set data:init to true.

  for script in archive:files:scripts:list:values {
    if script:isfile {
      local localPath is path(path(script):changeextension(""):name).

      fetchFile(script, localPath).

      runoncepath(localPath).
    }.
  }.
  
  set data:init to false.
}.

local function import {
  local parameter libName.

  if data:libs:haskey(libName)
    return data:libs[libName].

  data:libNames:push(libName).

  local fullName is "lib-" + libName.
  local localPath is path("1:/"):combine("libs", fullName).

  if data:init fetchFile(
    open(path("0:/"):combine("libs", fullName)),
    localPath
  ).

  runoncepath(localPath).

  return data:libs[data:libNames:pop()].
}.

local function fetchFile {
  local parameter remoteFile.
  local parameter localPath.

  local function copyFile {
    copypath(remoteFile, localPath:changeextension("ks")).
  }.

  if not exists(localPath) {
    if not data:debug {
      compile remoteFile to localPath:changeextension("ksm").
      local localFile is open(localPath).

      if remoteFile:size <= localFile:size {
        deletepath(localFile).
        copyFile().
      }.
    } else
      copyFile().
  }.
}.

local function export {
  local parameter funcs.

  data:libs:add(data:libNames:peek(), funcs).
}.
