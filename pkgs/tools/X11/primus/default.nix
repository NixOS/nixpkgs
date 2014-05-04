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
