{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, jdk8
, jdk17
, zlib
, file
, wrapQtAppsHook
, xorg
, libpulseaudio
, qtbase
, qtsvg
, qtwayland
, libGL
, quazip
, glfw
, openal
, extra-cmake-modules
, tomlplusplus
, ghc_filesystem
, msaClientID ? ""
, jdks ? [ jdk17 jdk8 ]
, gamemodeSupport ? true
, gamemode
}:

let
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    sha256 = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };
in

stdenv.mkDerivation rec {
  pname = "prismlauncher";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    rev = version;
    sha256 = "sha256-7tptHKWkbdxTn6VIPxXE1K3opKRiUW2zv9r6J05dcS8=";
  };

  nativeBuildInputs = [ extra-cmake-modules cmake file jdk17 ninja wrapQtAppsHook ];
  buildInputs = [
    qtbase
    qtsvg
    zlib
    quazip
    ghc_filesystem
    tomlplusplus
  ]
  ++ lib.optional (lib.versionAtLeast qtbase.version "6") qtwayland
  ++ lib.optional gamemodeSupport gamemode.dev;

  cmakeFlags = lib.optionals (msaClientID != "") [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ]
    ++ lib.optionals (lib.versionAtLeast qtbase.version "6") [ "-DLauncher_QT_VERSION_MAJOR=6" ];

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    mkdir source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus}/* source/libraries/libnbtplusplus
    chmod -R +r+w source/libraries/libnbtplusplus
    chown -R $USER: source/libraries/libnbtplusplus
  '';

  qtWrapperArgs =
    let
      libpath = with xorg;
        lib.makeLibraryPath ([
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
        ] ++ lib.optional gamemodeSupport gamemode.lib);
    in
    [
      "--set LD_LIBRARY_PATH /run/opengl-driver/lib:${libpath}"
      "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}"
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      "--prefix PATH : ${lib.makeBinPath [xorg.xrandr]}"
    ];

  meta = with lib; {
    homepage = "https://prismlauncher.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    changelog = "https://github.com/PrismLauncher/PrismLauncher/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minion3665 Scrumplex ];
  };
}
