{
  lib,
  stdenv,
  qtbase,
  qmake,
  inkscape,
  imagemagick,
  wrapQtAppsHook,
  wpa_supplicant,
}:

stdenv.mkDerivation {
  pname = "wpa_gui";
  inherit (wpa_supplicant) version src patches;

  buildInputs = [ qtbase ];
  nativeBuildInputs = [
    qmake
    inkscape
    imagemagick
    wrapQtAppsHook
  ];

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

  meta = {
    description = "Qt-based GUI for wpa_supplicant";
    mainProgram = "wpa_gui";
    homepage = "https://hostap.epitest.fi/wpa_supplicant/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
