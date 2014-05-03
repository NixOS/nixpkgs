{ stdenv
, primusLib_x64
, primusLib_i686
, writeScript
}:
let
  version = "1.0.0";
  primusrun = writeScript "primusrun"
''
  export LD_LIBRARY_PATH=${primusLib_x64}/lib:${primusLib_i686}/lib
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
}
