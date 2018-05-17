{ stdenv, callPackage, targetPlatform, windows }:
with stdenv.lib;
let inherit (callPackage ./common.nix {}) name src;
in stdenv.mkDerivation {

  name = name + "-msvcrt";
  inherit src;

  buildInputs = [ windows.mingw_w64_headers ];

  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];

  preConfigure = ''
    cd mingw-w64-crt
  '';

  postInstall = ''
    ln -s ${windows.mingw_w64_headers} $out/mingw
  '';
}
