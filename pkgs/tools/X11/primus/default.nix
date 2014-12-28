# For a 64bit + 32bit system the LD_LIBRARY_PATH must contain both the 32bit and 64bit primus
# libraries. Providing a different primusrun for each architecture will not work as expected. EG:
# Using steam under wine can involve both 32bit and 64bit process. All of which inherit the
# same LD_LIBRARY_PATH.
# Other distributions do the same.
{ stdenv
, primusLib
, writeScript
, primusLib_i686 ? null
}:
with stdenv.lib;
let
  version = "1.0.0748176";
  ldPath = makeLibraryPath ([primusLib] ++ optional (primusLib_i686 != null) primusLib_i686);
  primusrun = writeScript "primusrun"
''
  export LD_LIBRARY_PATH=${ldPath}:\$LD_LIBRARY_PATH
  # see: https://github.com/amonakov/primus/issues/138
  # On my system, as of 3.16.6, the intel driver dies when the pixel buffers try to read from the
  # source memory directly. Setting PRIMUS_UPLOAD causes an indirection through textures which
  # avoids this issue.
  export PRIMUS_UPLOAD=1
  exec "$@"
'';
in
stdenv.mkDerivation {
  name = "primus-${version}";
  builder = writeScript "builder"
  ''
  source $stdenv/setup
  mkdir -p $out/bin
  cp ${primusrun} $out/bin/primusrun
  '';

  meta = {
    homepage = https://github.com/amonakov/primus;
    description = "Faster OpenGL offloading for Bumblebee";
    maintainers = maintainers.coconnor;
  };
}
