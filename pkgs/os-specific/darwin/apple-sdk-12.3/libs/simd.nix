{ darwin-stubs, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-simd";
  inherit (darwin-stubs) version;

  buildCommand = ''
    mkdir -p $out/include
    cp -r ${darwin-stubs}/usr/include/simd $out/include
  '';
}
