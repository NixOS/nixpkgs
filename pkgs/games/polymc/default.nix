{ lib
, mkDerivation
, makeDesktopItem
, fetchFromGitHub
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

mkDerivation rec {
  pname = "polymc";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = version;
    sha256 = "sha256-8aya0KfV9F+i2qBpweWcR9hwyTSQkqn2wHdtkCEeNvk=";
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
  '';

  cmakeFlags = [ "-DLauncher_LAYOUT=lin-system" ] ++
               lib.optionals (msaClientID != "") [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ];

  desktopItems = [
    (makeDesktopItem {
      name = "polymc";
      desktopName = "PolyMC";
      genericName = "Minecraft Launcher";
      comment = "Free, open source launcher and instance manager for Minecraft.";
      icon = "launcher";
      exec = "polymc";
      categories = "Game";
      terminal = "false";
    })
  ];

  dontWrapQtApps = true;

  postInstall = let
    libpath = with xorg; lib.makeLibraryPath [
      libX11
      libXext
      libXcursor
      libXrandr
      libXxf86vm
      libpulseaudio
      libGL
    ];
  in ''
    install -Dm644 ../launcher/resources/multimc/scalable/launcher.svg $out/share/pixmaps/polymc.svg

    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/polymc \
      "''${qtWrapperArgs[@]}" \
      --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
      --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
  '';

  meta = with lib; {
    homepage = "https://polymc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
