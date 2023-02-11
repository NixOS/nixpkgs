{ lib, mkDerivation, fetchpatch, qtbase, qmake, inkscape, imagemagick, wpa_supplicant }:

mkDerivation {
  pname = "wpa_gui";
  inherit (wpa_supplicant) version src;

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake inkscape imagemagick ];

  postPatch = ''
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

  meta = with lib; {
    description = "Qt-based GUI for wpa_supplicant";
    homepage = "https://hostap.epitest.fi/wpa_supplicant/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
