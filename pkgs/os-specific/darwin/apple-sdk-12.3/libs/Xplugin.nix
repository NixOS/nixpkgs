{
  frameworks,
  darwin-stubs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "apple-lib-Xplugin";
  inherit (darwin-stubs) version;

  dontUnpack = true;
  dontBuild = true;

  propagatedBuildInputs = with frameworks; [
    OpenGL
    ApplicationServices
    Carbon
    IOKit
    CoreGraphics
    CoreServices
    CoreText
  ];

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp "${darwin-stubs}/include/Xplugin.h" $out/include/Xplugin.h
    cp ${darwin-stubs}/usr/lib/libXplugin.1.tbd $out/lib
    ln -s libXplugin.1.tbd $out/lib/libXplugin.tbd
  '';
}
