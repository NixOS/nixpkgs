{ pkgs, lib, stdenv, qtbase, wrapQtAppsHook, qttools, makeDesktopItem, copyDesktopItems, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "mcontrolcenter";
  version = "0.4.1";

  desktopItems = [
    (makeDesktopItem {
      name = "MControlCenter";
      exec = "mcontrolcenter";
      icon = "mcontrolcenter";
      comment = finalAttrs.meta.description;
      desktopName = "MControlCenter";
      categories = [ "System" ];
    })
  ];

  buildInputs = [
    pkgs.cmake
    qtbase
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    qttools
    copyDesktopItems
  ];

  src = fetchFromGitHub {
    owner = "dmitry-s93";
    repo = "MControlCenter";
    rev = "f04ca9878f0ccfa5ea849a3bd17bcb79a5f52a0a";
    hash = "sha256-SV78OVRGzy2zFLT3xqeUtbjlh81Z97PVao18P3h/8dI=";
  };

  patches = [ ./modprobe.patch ];

  cmakeFlags = [
    "-DENABLE_TESTING=OFF"
    "-DENABLE_INSTALL=ON"
  ];

  installPhase = ''
    install -Dm755 mcontrolcenter $out/bin/mcontrolcenter
    install -Dm755 helper/mcontrolcenter-helper $out/libexec/mcontrolcenter-helper
    install -Dm644  $src/resources/mcontrolcenter.svg $out/share/icons/hicolor/32x32/apps/mcontrolcenter.svg
    install -Dm644 $src/src/helper/mcontrolcenter-helper.conf $out/share/dbus-1/system.d/mcontrolcenter-helper.conf
    mkdir -p $out/share/dbus-1/system-services
    echo "[D-BUS Service]" >> $out/share/dbus-1/system-services/mcontrolcenter.helper.service
    echo "Name=mcontrolcenter.helper" >> $out/share/dbus-1/system-services/mcontrolcenter.helper.service
    echo "Exec=$out/libexec/mcontrolcenter-helper" >> $out/share/dbus-1/system-services/mcontrolcenter.helper.service
    echo "User=root" >> $out/share/dbus-1/system-services/mcontrolcenter.helper.service
  '';

  meta = with lib; {
    homepage = "https://github.com/dmitry-s93/MControlCenter";
    description = "An application that allows you to change the settings of MSI laptops running Linux.";
    licencse = licenses.gpl3;
    platforms = with platforms; linux;
    # maintainers = [ maintainers.nadimkobeissi ];
  };
})
