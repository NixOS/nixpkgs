{ stdenv, appimageTools, lib, fetchurl, makeDesktopItem }:
let
  name = "lunar-client";
  version = "2.4.0";

  desktopItem = makeDesktopItem {
    name = "Lunar Client";
    exec = "lunar-client";
    icon = "lunarclient";
    comment = "Optimized Minecraft Client for 1.7.10 and 1.8.9";
    desktopName = "Lunar Client";
    genericName = "Minecraft Client";
    categories = "Game;";
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    name = "lunar-client.AppImage";
    sha256 = "bb85a62127a9b3848cc60796c20ac75655794f1d3cd17cb6b5499bbf19d16019";
  };
in appimageTools.wrapType1 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    cp -r ${appimageContents}/usr/share/icons/ $out/share/
  '';

  meta = with lib; {
    description = "Minecraft 1.7.10 & 1.8.9 PVP Client";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ zyansheep ];
    platforms = [ "x86_64-linux" ];
  };
}
