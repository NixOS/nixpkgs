{ lib
, stdenv
, symlinkJoin
, prismlauncher-unwrapped
, wrapQtAppsHook
, qtbase  # needed for wrapQtAppsHook
, qtsvg
, qtwayland
, xorg
, libpulseaudio
, libGL
, glfw
, openal
, jdk8
, jdk17
, gamemode

, msaClientID ? null
, gamemodeSupport ? stdenv.isLinux
, jdks ? [ jdk17 jdk8 ]
, additionalLibs ? [ ]
}:
let
  prismlauncherFinal = prismlauncher-unwrapped.override {
    inherit msaClientID gamemodeSupport;
  };
in
symlinkJoin {
  name = "prismlauncher-${prismlauncherFinal.version}";

  paths = [ prismlauncherFinal ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
  ]
  ++ lib.optional (lib.versionAtLeast qtbase.version "6" && stdenv.isLinux) qtwayland;

  postBuild = ''
    wrapQtAppsHook
  '';

  qtWrapperArgs =
    let
      libs = (with xorg; [
        libX11
        libXext
        libXcursor
        libXrandr
        libXxf86vm
      ])
      ++ [
        libpulseaudio
        libGL
        glfw
        openal
        stdenv.cc.cc.lib
      ]
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ additionalLibs;

    in
    [ "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}" ]
    ++ lib.optionals stdenv.isLinux [
      "--set LD_LIBRARY_PATH /run/opengl-driver/lib:${lib.makeLibraryPath libs}"
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      "--prefix PATH : ${lib.makeBinPath [xorg.xrandr]}"
    ];

  inherit (prismlauncherFinal) meta;
}
