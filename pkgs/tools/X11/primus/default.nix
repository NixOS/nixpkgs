# For a 64bit + 32bit system the LD_LIBRARY_PATH must contain both the 32bit and 64bit primus
# libraries. Providing a different primusrun for each architecture does not work as expected. Using
# steam under wine, for instance, can involve both 32bit and 64bit process. All of which inherit the
# same LD_LIBRARY_PATH.
# Other distributions do much the same.
{ stdenv
, primusLib
, writeScript
, primusLib_i686 ? null
}:
with stdenv.lib;
let
  version = "1.074817614c";
  ld_path = makeLibraryPath ([primusLib] ++ optional (primusLib_i686 != null) primusLib_i686);
  primusrun = writeScript "primusrun"
''
  export LD_LIBRARY_PATH=${ld_path}
  # see: https://github.com/amonakov/primus/issues/138
  # I think the intel driver dies when the pixel buffers try to read from the source memory
  # directly. Setting PRIMUS_UPLOAD causes an indirection through textures which appears to avoid
  # this issue.
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
    maintainer = maintainers.coconnor;
  };
}
