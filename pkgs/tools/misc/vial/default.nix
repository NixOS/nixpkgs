{ lib, fetchurl, appimageTools }:
let
  version = "0.7.1";
  pname = "Vial";

  src = fetchurl {
    url = "https://github.com/vial-kb/vial-gui/releases/download/v${version}/${pname}-v${version}-x86_64.AppImage";
    hash = "sha256-pOcrxZ6vbnbdE/H4Kxufxm/ZovaYBXjFpVpKZYV7f3c=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    mkdir -p $out/etc/udev/rules.d/ # https://get.vial.today/getting-started/linux-udev.html
    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' > $out/etc/udev/rules.d/92-viia.rules
  '';

  meta = {
    description = "Open-source GUI and QMK fork for configuring your keyboard in real time";
    homepage = "https://get.vial.today";
    license = lib.licenses.gpl2Plus;
    mainProgram = "Vial";
    maintainers = with lib.maintainers; [ kranzes ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
