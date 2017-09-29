{ stdenv, fetchurl, qtbase, qmake, inkscape, imagemagick, wpa_supplicant }:

stdenv.mkDerivation {
  name = "wpa_gui-${wpa_supplicant.version}";

  inherit (wpa_supplicant) src;

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake inkscape imagemagick ];

  prePatch = ''
    cd wpa_supplicant/wpa_gui-qt4
  '';

  postBuild = ''
    make -C icons
  '';

  postInstall = ''
    mkdir -pv $out/{bin,share/applications,share/icons}
    cp -v wpa_gui $out/bin
    cp -v wpa_gui.desktop $out/share/applications
    cp -av icons/hicolor $out/share/icons
  '';

  meta = {
    description = "Qt-based GUI for wpa_supplicant";
    platforms = stdenv.lib.platforms.linux;
  };
}
