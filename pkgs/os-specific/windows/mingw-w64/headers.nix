{ stdenvNoCC, callPackage, hostPlatform, targetPlatform }:

let
  inherit (callPackage ./common.nix {}) name src;

in stdenvNoCC.mkDerivation {
  name = name + "-headers" + stdenvNoCC.lib.optionalString (targetPlatform != hostPlatform) "-${targetPlatform.config}";
  inherit src;

  # https://sourceforge.net/p/mingw-w64/wiki2/Cross%20Win32%20and%20Win64%20compiler/
  # specifies that the headers should be in
  prefix = "\${out}/${targetPlatform.config}";

  preConfigure = ''
    cd mingw-w64-headers
  '';
}
