{ appimageTools
, fetchurl
, lib
}:

let
  pname = "lunar-client";
  version = "3.0.10";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha256-mbEV+iciL4+PtfvStyXZXK5Zb91N9H1VJ5amZj+2EyA=";
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
    platforms = [ "x86_64-linux" ];
  };
}
