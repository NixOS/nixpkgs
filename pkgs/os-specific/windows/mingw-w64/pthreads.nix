{ stdenv, callPackage }:

let
  inherit (callPackage ./common.nix {}) name src;

in stdenv.mkDerivation {
  name = name + "-pthreads";
  inherit src;

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
}
