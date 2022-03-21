{ lib, fetchurl, appimageTools, gsettings-desktop-schemas, gtk3 }:

let
  pname = "heroic";
  version = "2.2.1";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${version}/Heroic-${version}.AppImage";
    sha256 = "sha256-zzxf3eM1fUWTVtzzABcwlmptNuCVQafvotnbOiCzu0c=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}

    install -m 444 -D ${appimageContents}/heroic.desktop -t $out/share/applications

    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/heroic.desktop \
      --replace 'Exec=AppRun' 'Exec=heroic'
  '';

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  meta = with lib; {
    description = "A Native GUI Epic Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
