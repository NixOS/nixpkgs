{ darwin-stubs, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-sandbox";
  inherit (darwin-stubs) version;

  buildCommand = ''
    mkdir -p $out/include $out/lib
    cp "${darwin-stubs}/usr/include/sandbox.h" $out/include/sandbox.h
    cp "${darwin-stubs}/usr/lib/libsandbox.1.tbd" $out/lib
    ln -s libsandbox.1.tbd $out/lib/libsandbox.tbd
  '';
}
