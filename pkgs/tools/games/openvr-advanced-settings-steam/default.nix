{ lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "openvr-advanced-settings-steam";
  version = "5.8.11";
  commit = "72e91e9";
  src = fetchurl {
    url = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings/releases/download/v${version}/OpenVR_Advanced_Settings-${commit}-STEAM-x86_64.AppImage";
    hash = "sha256-YDrj68//84tyyZyL0okUEzy3a+59nNwVoyTGToDpKpc=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    ls ${appimageContents} -l
    install -Dm444 ${appimageContents}/AdvancedSettings.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/AdvancedSettings.desktop \
      --replace 'Exec=AdvancedSettings' 'Exec=openvr-advanced-settings-steam --desktop-mode'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Adds an overlay to the OpenVR dashboard that allows access to advanced settings and useful utilities";
    homepage = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings";
    changelog = "https://github.com/OpenVR-Advanced-Settings/OpenVR-AdvancedSettings/tree/v${version}";
    license = licenses.gpl3Only;
    mainProgram = "openvr-advanced-settings-steam";
    maintainers = with maintainers; [ different ];
    platforms = [ "x86_64-linux" ];
  };
}
