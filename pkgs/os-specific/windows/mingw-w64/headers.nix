{ stdenvNoCC, callPackage, hostPlatform, targetPlatform }:

let
  inherit (callPackage ./common.nix {}) name src;

in stdenvNoCC.mkDerivation {
  name = name + "-headers" + stdenvNoCC.lib.optionalString (targetPlatform != hostPlatform) "-${targetPlatform.config}";
  inherit src;

  preConfigure = ''
    cd mingw-w64-headers
  '';

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
    # "--with-default-win32-winnt=0x600"
  ];
}
