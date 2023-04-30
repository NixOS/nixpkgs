{
  frameworks,
  MacOSX-SDK,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "apple-lib-Xplugin";
  dontUnpack = true;
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
    ln -s "${MacOSX-SDK}/include/Xplugin.h" $out/include/Xplugin.h
    cp ${MacOSX-SDK}/usr/lib/libXplugin.1.tbd $out/lib
    ln -s libXplugin.1.tbd $out/lib/libXplugin.tbd
  '';
}
