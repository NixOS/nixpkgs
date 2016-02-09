# For a 64bit + 32bit system the LD_LIBRARY_PATH must contain both the 32bit and 64bit primus
# libraries. Providing a different primusrun for each architecture will not work as expected. EG:
# Using steam under wine can involve both 32bit and 64bit process. All of which inherit the
# same LD_LIBRARY_PATH.
# Other distributions do the same.
{ stdenv
, primusLib
, writeScriptBin
, primusLib_i686 ? null
, useNvidia ? true
}:

let
  primus = if useNvidia then primusLib else primusLib.override { nvidia_x11 = null; };
  primus_i686 = if useNvidia then primusLib_i686 else primusLib_i686.override { nvidia_x11 = null; };
  ldPath = stdenv.lib.makeLibraryPath ([primus] ++ stdenv.lib.optional (primusLib_i686 != null) primus_i686);

in writeScriptBin "primusrun" ''
  #!${stdenv.shell}
  export LD_LIBRARY_PATH=${ldPath}:$LD_LIBRARY_PATH
  exec "$@"
''
