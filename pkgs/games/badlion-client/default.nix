{ lib, fetchurl, appimageTools }:

let
  pname = "badlion-client";
  version = "4.1.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20240318143435/https://client-updates-cdn77.badlion.net/BadlionClient";
    hash = "sha256-dayClA7dinwktioW7FSADJPqifN02Q8i5Jo/HfPGlp8=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      mv $out/bin/{${pname}-${version},${pname}}
      install -Dm444 ${appimageContents}/BadlionClient.desktop $out/share/applications/BadlionClient.desktop
      install -Dm444 ${appimageContents}/BadlionClient.png $out/share/pixmaps/BadlionClient.png
      substituteInPlace $out/share/applications/BadlionClient.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=badlion-client'
    '';

    meta = with lib; {
      description = "The Most Complete All-In-One Mod Library for Minecraft with 100+ Mods, FPS Improvements, and more";
      homepage = "https://client.badlion.net";
      license = with licenses; [ unfree ];
      maintainers = with maintainers; [ starzation ];
      platforms = platforms.linux;
    };
  }
