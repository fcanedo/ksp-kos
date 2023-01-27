@lazyglobal off.

{
  local st is stack().
  
  local libs is lex().
  
  global import is {
    local parameter libName.
    local parameter libDir is "".
    local parameter compilation is true.
  
  
    if libs:haskey(libName) return libs:libName.
    else {
      local fileName is "lib-" + libName + ".ks".
      local localPath is
        path("1:/"):combine(fileName).

      // empty strings are ignored by `combine`, so this does
      // the right thing
      local remotePath is path("0:/"):combine(libDir, fileName).

      st:push(libName).
  
      if compilation set localPath to localPath:changeextension("ksm").

      if not exists(localPath) {
        if compilation {
          compile remotePath to localPath.
        } else {
          copypath(remotePath, localPath).
        }.
      }.
      runoncepath(localPath).
  
      return libs[st:pop()].
    }
  }.
  
  global export is {
    local parameter funcs.
  
    set libs[st:peek()] to funcs.
  }.
}
