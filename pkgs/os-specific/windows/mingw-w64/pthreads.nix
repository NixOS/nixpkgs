{ stdenv, mingw_w64 }:

stdenv.mkDerivation {
  name = "${mingw_w64.name}-pthreads";
  inherit (mingw_w64) src meta;

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
}
