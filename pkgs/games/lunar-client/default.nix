<<<<<<< HEAD
{ appimageTools
, fetchurl
, lib
}:

let
  pname = "lunar-client";
  version = "3.0.7";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha256-JpgKxCFXO+oK9D7gpk6AfiZLWzgFlijVWKhvfkBrJwY=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -Dm444 ${appimageContents}/launcher.desktop $out/share/applications/lunar-client.desktop
    install -Dm444 ${appimageContents}/launcher.png $out/share/pixmaps/lunar-client.png
    substituteInPlace $out/share/applications/lunar-client.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=lunar-client' \
      --replace 'Icon=launcher' 'Icon=lunar-client'
  '';

  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost.";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ zyansheep Technical27 surfaceflinger ];
=======
{ appimageTools, lib, fetchurl, makeDesktopItem }:

let
  name = "lunar-client";
  version = "2.15.1";

  desktopItem = makeDesktopItem {
    name = "lunar-client";
    exec = "lunar-client";
    icon = "lunarclient";
    comment = "Minecraft 1.7, 1.8, 1.12, 1.15, 1.16, 1.17, and 1.18 Client";
    desktopName = "Lunar Client";
    genericName = "Minecraft Client";
    categories = [ "Game" ];
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    name = "lunar-client.AppImage";
    hash = "sha256-8F6inLctNLCrTvO/f4IWHclpm/6vqW44NKbct0Epp4s=";
  };
in
appimageTools.wrapType1 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    cp -r ${appimageContents}/usr/share/icons/ $out/share/
  '';

  extraPkgs = pkgs: [ pkgs.libpulseaudio ];

  meta = with lib; {
    description = "Minecraft 1.7, 1.8, 1.12, 1.15, 1.16, 1.17, and 1.18 Client";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ zyansheep Technical27 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
  };
}
