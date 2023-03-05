@lazyglobal off.

{
  local st is stack().
  
  local libs is lex().

  local globalDebug is false.
  
  global import is {
    local parameter libName.
    local parameter libDir is "".
    local parameter debug is false.

    if libs:haskey(libName) return libs[libName].
    else {
      // once one library is not to be compiled, we won't compile any more
      set globalDebug to globalDebug or debug.

      local fileName is "lib-" + libName + ".ks".
      local localPath is
        path("1:/"):combine(fileName).

      // empty strings are ignored by `combine`, so this does
      // the right thing
      local remotePath is path("0:/"):combine(libDir, fileName).

      st:push(libName).
  
      if globalDebug {
        print "localPath: [" + localPath + "]".
        print "exists: [" + exists(localPath) + "]".
        if exists(localPath) deletepath(localPath).
        local ksmPath is localPath:changeextension("ksm").
        print "ksmPath: [" + ksmPath + "]".
        print "exists: [" + exists(ksmPath) + "]".
        if exists(ksmPath) deletepath(ksmPath).
      } else{
        print "nope".
        set localPath to localPath:changeextension("ksm").
      }.

      if not exists(localPath) or globalDebug {
        if not globalDebug {
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
