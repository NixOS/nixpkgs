{ lib, mkDerivation, fetchpatch, qtbase, qmake, inkscape, imagemagick, wpa_supplicant }:

mkDerivation {
  name = "wpa_gui-${wpa_supplicant.version}";

  inherit (wpa_supplicant) src;

  patches = [
    # Fix build with Inkscape 1.0
    # https://github.com/NixOS/nixpkgs/issues/86930
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=0388992905a5c2be5cba9497504eaea346474754";
      sha256 = "05hs74qawa433adripzhycm45g7yvxr6074nd4zcl4gabzp9hd30";
    })
  ];

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
