{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "badlion-client";
  version = "3.15.0";

  src = fetchurl {
    url = "https://client-updates-cdn77.badlion.net/BadlionClient";
    hash = "sha256-HqMgY9+Xnp4uSTWr//REZGv3p7ivwLX97vxGD5wqu9E=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/BadlionClient.desktop $out/share/applications/BadlionClient.desktop
    install -Dm444 ${appimageContents}/BadlionClient.png $out/share/pixmaps/BadlionClient.png
    substituteInPlace $out/share/applications/BadlionClient.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=badlion-client'
  '';

  meta = with lib; {
    description = "The Most Complete All-In-One Mod Library for Minecraft with 100+ Mods, FPS Improvements, and more";
    homepage = "https://client.badlion.net";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
