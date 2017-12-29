{ stdenv, buildFHSUserEnv, runescape-launcher-runtime }:

buildFHSUserEnv rec {
  name = "runescape-launcher-wrapper-${runescape-launcher-runtime.version}";

  runScript = "${runescape-launcher-runtime}/bin/runescape-launcher";

  targetPkgs = pkgs: with pkgs // pkgs.xorg; [
    libSM
    libX11
    libXxf86vm
    libpng12
    glib
    glib_networking
    pango
    cairo
    gdk_pixbuf
    curl
    gtk2
    expat
    SDL2
    zlib
    glew110
    mesa
  ];
}
