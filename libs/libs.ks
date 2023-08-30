@lazyglobal off.

global lib is lexicon(
  "init", init@,
  "initLib", initLib@,
  "deleteLib", deleteLib@,
  "import", import@,
  "export", export@,
  "execute", execute@,
  "initScript", initOneScript@
).

local data is lexicon(
 "libs", lexicon(),
 "libNames", stack(),
 "init", false,
 "debug", false
).

local archiveLibDir is path("0:/"):combine("libs").
local localLibDir is path("1:/"):combine("/libs").

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
      initScript(script).
    }.
  }.
  
  set data:init to false.
}.

local function initLib {
  local parameter libName.

  set data:init to true.
  local lib is import(libName).
  set data:init to false.

  return lib.
}.

local function initOneScript {
  local parameter script.

  set data:init to true.
  initScript(script).
  set data:init to false.
}.

local function initScript {
  local parameter script.

  local localPath is path(path(script):changeextension(""):name).

  fetchFile(script, localPath).

  runoncepath(localPath).
}.

local function getFullName {
  local parameter libName.

  return "lib-" + libName.
}.

local function import {
  local parameter libName.

  if data:libs:haskey(libName)
    return data:libs[libName].

  data:libNames:push(libName).

  local fullName is getFullName(libName).
  local archivePath is archiveLibDir:combine(fullName).

  if scriptpath():volume = archive {
    // We're running on the archive, just load the library.
    runoncepath(archivePath:changeextension("ks")).
  } else {
    local localPath is localLibDir:combine(fullName).

    if data:init fetchFile(open(archivePath), localPath).

    runoncepath(localPath).
  }.

  return data:libs[data:libNames:pop()].
}.

local function deleteLib {
  local parameter libName.

  // We're running on the archive, do nothing
  if scriptpath():volume = archive return.

  local libFile is localLibDir:combine(getFullName(libName)).
  // delete needs a non-relative path witouth the volume as a string
  core:volume:delete("/" + libFile:segments:join("/")).
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
