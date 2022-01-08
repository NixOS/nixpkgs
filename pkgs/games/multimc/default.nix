{ lib
, mkDerivation
, fetchFromGitHub
, makeDesktopItem
, substituteAll
, fetchpatch
, cmake
, jdk8
, jdk
, zlib
, file
, makeWrapper
, xorg
, libpulseaudio
, qtbase
, libGL
, msaClientID ? ""
}:

let
  gameLibraryPath = with xorg; lib.makeLibraryPath [
    libX11
    libXext
    libXcursor
    libXrandr
    libXxf86vm
    libpulseaudio
    libGL
  ];
in

mkDerivation rec {
  pname = "multimc";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = version;
    sha256 = "7tM+z35dtUIN/UioJ7zTP8kdRKlTJIrWRkA08B8ci3A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk8 zlib ];

  patches = [
    (fetchpatch {
      name = "revert-lin-system-installation.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-Readd-lin-system-and-LAUNCHER_LINUX_DATADIR.patch?h=multimc5&id=baf9bef2b7782abb234be9f879df4fe8fc3cb22a";
      sha256 = "sha256-JOQ2jIAcSJfzMRqR4jGwK1vyJwTf/V7O/bdh3UMfwUg=";
    })
    (fetchpatch {
      name = "mmc-brand.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/mmc-brand.patch?h=multimc5&id=baf9bef2b7782abb234be9f879df4fe8fc3cb22a";
      sha256 = "sha256-1bBEfD9TrQrwuzIDBsj6OW0/kKiKOK4y0IJoFzNk1SY=";
    })
    (fetchpatch {
      name = "fix-jar-locations.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-jars.patch?h=multimc5&id=baf9bef2b7782abb234be9f879df4fe8fc3cb22a";
      sha256 = "sha256-QlhlJ5TbXtrmElzHsAnHdzmplWr3G9LJm9UT8HTWmAI=";
    })
    (substituteAll {
      src = ./hardcode-jdk-paths.patch;
      jdk = jdk;
      jdk8 = jdk8;
    })
  ];

  postPatch = ''
    # add client ID
    substituteInPlace notsecrets/Secrets.cpp \
      --replace 'QString MSAClientID = "";' 'QString MSAClientID = "${msaClientID}";'
  '';

  cmakeFlags = [
    "-DLauncher_LAYOUT=lin-system"
    "-DLauncher_APP_BINARY_NAME=${pname}"
    "-DLauncher_SHARE_DEST_DIR=share/${pname}"
  ];

  desktopItem = makeDesktopItem {
    name = "multimc";
    exec = "multimc";
    icon = "multimc";
    desktopName = "MultiMC";
    genericName = "Minecraft Launcher";
    comment = meta.description;
    categories = "Game;";
    extraEntries = ''
      Keywords=game;Minecraft;
    '';
  };

  postInstall = ''
    install -Dm644 ../launcher/package/ubuntu/multimc/opt/multimc/icon.svg $out/share/pixmaps/multimc.svg
    install -Dm755 ${desktopItem}/share/applications/multimc.desktop -t $out/share/applications

    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/multimc \
      --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${gameLibraryPath} \
      --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
  '';

  meta = with lib; {
    homepage = "https://multimc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of
      Minecraft (each with their own mods, texture packs, saves, etc)
      and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.asl20;
    # upstream don't want us to re-distribute this application:
    # https://github.com/NixOS/nixpkgs/issues/131983
    hydraPlatforms = [];
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
