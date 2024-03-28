{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, makeDesktopItem, copyDesktopItems
, libGL, libGLU, SDL2, SDL2_net, gtk2, glib, bzip2
, openal, libogg, libvorbis, libjpeg, freetype
, overgrowth-data ? "" }:

stdenv.mkDerivation rec {
  pname = "overgrowth";
  version = "unstable-2023-05-17";

  src = fetchFromGitHub {
    owner = "WolfireGames";
    repo = pname;
    rev = "594a2a4f9da0855304ee8cd5335d042f8e954ce1";
    hash = "sha256-gsVI0eFONfO3fgHpcbAnc1FYS/J3/jWDIUYqs++XfEs=";
  };

  desktopItems = [ (makeDesktopItem {
    name = "overgrowth";
    desktopName = "Overgrowth";
    icon = "overgrowth";
    exec = "overgrowth";
    path = overgrowth-data;
    categories = [ "Game" ];
  }) ];

  nativeBuildInputs = [ cmake pkg-config copyDesktopItems ];
  buildInputs = [
    libGL libGLU SDL2 SDL2_net gtk2 glib bzip2
    openal libogg libvorbis libjpeg freetype
  ];

  cmakeFlags = [
    "-S../Projects"
    "-DAUX_DATA=${overgrowth-data}"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${lib.getLib gtk2}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${lib.getLib glib}/lib/glib-2.0/include"
  ];
  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall
    install -D Overgrowth.bin.* $out/bin/overgrowth
    install -D $src/Projects/OGIcon.png\
      $out/share/icons/hicolor/1024x1024/apps/overgrowth.png
    runHook postInstall
  '';

  meta = {
    description = "Engine of Overgrowth, a rabbit fighting game";
    homepage = "https://overgrowth.wolfire.com";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.McSinyx ];
    platforms = lib.platforms.linux;
  };
}
