{ lib, mkDerivation, makeDesktopItem, fetchFromGitHub, cmake, jdk8, jdk, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase, libGL, msaClientID ? "" }:

let
  libpath = with xorg; lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio libGL ];
in mkDerivation rec {
  pname = "multimc";
  version = "0.6.14";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "Launcher";
    rev = "0.6.14";
    sha256 = "sha256-7tM+z35dtUIN/UioJ7zTP8kdRKlTJIrWRkA08B8ci3A=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk8 zlib ];

  patches = [ ./0001-pick-latest-java-first.patch ];

  postPatch = ''
    # hardcode jdk paths
    substituteInPlace launcher/java/JavaUtils.cpp \
      --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${jdk}/lib/openjdk/bin/java")' \
      --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${jdk8}/lib/openjdk/bin/java")'

    # add client ID
    substituteInPlace notsecrets/Secrets.cpp \
      --replace 'QString MSAClientID = "";' 'QString MSAClientID = "${msaClientID}";'
  '';

  cmakeFlags = [ "-DLauncher_LAYOUT=lin-nodeps" ];

  desktopItem = makeDesktopItem {
    name = "multimc";
    desktopName = "MultiMC";
    genericName = "Minecraft Launcher";
    comment = "Free, open source launcher and instance manager for Minecraft.";
    icon = "launcher";
    exec = "DevLauncher";
    categories = "Game";
    terminal = "false";
  };

  preFixup = ''
    mkdir -p $out/lib
    mv $out/bin/*.so $out/lib/
  '';

  postInstall = ''
    install -Dm644 ../launcher/resources/multimc/scalable/launcher.svg $out/share/pixmaps/multimc.svg
    install -Dm755 ${desktopItem}/share/applications/multimc.desktop $out/share/applications/multimc.desktop

    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/DevLauncher \
      --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
      --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]} \
      --add-flags '-d "''${XDG_DATA_HOME-$HOME/.local/share}/DevLauncher"'
  '';

  meta = with lib; {
    homepage = "https://multimc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with their own mods, texture packs, saves, etc) and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.asl20;
    # upstream don't want us to re-distribute this application:
    # https://github.com/NixOS/nixpkgs/issues/131983
    hydraPlatforms = [];
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
