{ darwin-stubs, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-xpc";
  inherit (darwin-stubs) version;

  buildCommand = ''
    mkdir -p $out/include
    cp -r "${darwin-stubs}/usr/include/xpc" $out/include/xpc
    cp "${darwin-stubs}/usr/include/launch.h" $out/include/launch.h
  '';
}
