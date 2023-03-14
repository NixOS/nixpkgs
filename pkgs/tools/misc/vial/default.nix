{ lib, fetchurl, appimageTools }:
let
  name = "vial-${version}";
  version = "0.6";
  pname = "Vial";

  src = fetchurl {
    url = "https://github.com/vial-kb/vial-gui/releases/download/v${version}/${pname}-v${version}-x86_64.AppImage";
    sha256 = "sha256-2EapikmY79KQdoHnz1A7gErVXBN8D80r1GJMKQ5gIM0=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    mkdir -p $out/etc/udev/rules.d/ # https://get.vial.today/getting-started/linux-udev.html
    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' > $out/etc/udev/rules.d/92-viia.rules
  '';

  meta = with lib; {
    description = "An Open-source QMK GUI fork for configuring your keyboard in real time";
    homepage = "https://get.vial.today";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes ];
    platforms = [ "x86_64-linux" ];
  };
}
