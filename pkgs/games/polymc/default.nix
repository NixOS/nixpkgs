{ lib
, stdenv
, fetchFromGitHub
, cmake
, jdk8
, jdk
, zlib
, file
, wrapQtAppsHook
, xorg
, libpulseaudio
, qtbase
, libGL
, quazip
, glfw
, openal
, msaClientID ? ""
, jdks ? [ jdk jdk8 ]
, extra-cmake-modules
}:

stdenv.mkDerivation rec {
  pname = "polymc";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = version;
    sha256 = "sha256-Pu2Eb3g6gwCZjJN0N6S/N82eBMLduQQUzXo8nMmtE+Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ extra-cmake-modules cmake file jdk wrapQtAppsHook ];
  buildInputs = [ qtbase zlib quazip ];

  cmakeFlags = lib.optionals (msaClientID != "") [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ];

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
      stdenv.cc.cc.lib
    ];
  in ''
    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapQtApp $out/bin/polymc \
      --set LD_LIBRARY_PATH /run/opengl-driver/lib:${libpath} \
      --prefix POLYMC_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks} \
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
