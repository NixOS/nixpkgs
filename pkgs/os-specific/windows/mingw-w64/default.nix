{ stdenv, callPackage, targetPlatform }:
with stdenv.lib;
let inherit (callPackage ./common.nix {}) name src;
in stdenv.mkDerivation {
#  buildInputs = [ windows.mingw_w64_headers ];

  name = name + "-msvcrt";
  inherit src;

  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];

  # https://sourceforge.net/p/mingw-w64/wiki2/Cross%20Win32%20and%20Win64%20compiler/
  # specifies that the headers should be in
  prefix = "\${out}/${targetPlatform.config}";

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];
}
