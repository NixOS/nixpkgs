{ stdenv, fetchurl, qt4, qmake4Hook, inkscape, wpa_supplicant }:

stdenv.mkDerivation {
  name = "wpa_gui-${wpa_supplicant.version}";

  inherit (wpa_supplicant) src;

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ inkscape qmake4Hook ];

  prePatch = "cd wpa_supplicant/wpa_gui-qt4";

  preConfigure =
    ''
      lrelease wpa_gui.pro
    '';

  # We do not install .xpm icons. First of all, I don't know where they should
  # be install. Second, this allows us to drop imagemagick build-time dependency.
  postBuild =
    ''
      sed -e '/ICONS.*xpm/d' -i icons/Makefile
      make -C icons
    '';

  installPhase =
    ''
      mkdir -pv $out/bin
      cp -v wpa_gui $out/bin
      mkdir -pv $out/share/applications
      cp -v wpa_gui.desktop $out/share/applications
      mkdir -pv $out/share/icons
      cp -av icons/hicolor $out/share/icons
    '';

  meta = {
    description = "Qt-based GUI for wpa_supplicant";
    platforms = stdenv.lib.platforms.linux;
  };
}
