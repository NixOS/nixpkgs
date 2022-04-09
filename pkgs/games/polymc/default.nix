{ lib
, mkDerivation
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
, glfw
, openal
, msaClientID ? ""
}:

mkDerivation rec {
  pname = "polymc";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = version;
    sha256 = "sha256-virXfnjCzuR2cJoyzapIopT9B+Yi1neff2ZqfOvsmxY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk8 zlib ];

  postPatch = ''
    # hardcode jdk paths
    substituteInPlace launcher/java/JavaUtils.cpp \
      --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${jdk}/lib/openjdk/bin/java")' \
      --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${jdk8}/lib/openjdk/bin/java")'
  '';

  cmakeFlags = [ "-DLauncher_PORTABLE=0" ] ++
               lib.optionals (msaClientID != "") [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ];

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
      glfw
      openal
    ];
  in ''
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
    changelog = "https://github.com/PolyMC/PolyMC/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
