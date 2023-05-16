{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  name = "steam-rom-manager";
<<<<<<< HEAD
  version = "2.4.17";

  src = fetchurl {
    url = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v${version}/Steam-ROM-Manager-${version}.AppImage";
    sha256 = "sha256-NRqryY9v6s51/eoCdqqID6m5Osx5PPChKGxjmLhh7ac=";
=======
  version = "2.3.40";

  src = fetchurl {
    url = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v${version}/Steam-ROM-Manager-${version}.AppImage";
    sha256 = "sha256-qm7F1/+3iVtsxSAptbhiI5sEHR0B9vo7AdEPy1/PANU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extract { inherit name src; };
    in ''
      install -m 444 -D ${appimageContents}/${name}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "An app for managing ROMs in Steam";
    homepage = "https://github.com/SteamGridDB/steam-rom-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ squarepear ];
    platforms = [ "x86_64-linux" ];
  };
}
