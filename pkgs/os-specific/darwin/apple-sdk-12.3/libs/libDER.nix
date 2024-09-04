{ darwin-stubs, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-libDER";
  inherit (darwin-stubs) version;

  buildCommand = ''
    mkdir -p $out/include
    cp -r ${darwin-stubs}/usr/include/libDER $out/include
  '';
}
