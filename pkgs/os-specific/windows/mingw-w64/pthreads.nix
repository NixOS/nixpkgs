{ stdenv, callPackage, windows }:
with stdenv.lib;
let inherit (callPackage ./common.nix {}) name src;
in stdenv.mkDerivation {
  name = name + "-pthreads";
  inherit src;

  buildInputs = [ windows.mingw_w64_headers windows.mingw_w64 ];

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';

  hardeningDisable = [ "stackprotector" ];
}
