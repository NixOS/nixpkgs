{ darwin-stubs, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-utmp";
  inherit (darwin-stubs) version;

  buildCommand = ''
    mkdir -p $out/include
    cp "${darwin-stubs}/include/utmp.h" $out/include
    cp "${darwin-stubs}/include/utmpx.h" $out/include
  '';
}
