<<<<<<< HEAD
{ lib
, fetchzip
, fetchFromGitHub
, stdenv
, fetchpatch
, copyDesktopItems
, curl
, makeBinaryWrapper
, pkg-config
, which
, freetype
, libglvnd
, libjpeg
, libogg
, libvorbis
, libxmp
, openal
, SDL2
, speex
, makeDesktopItem
}:

let
  openarena-maps = fetchzip {
    name = "openarena-maps";
    url = "https://download.tuxfamily.org/openarena/rel/088/openarena-0.8.8.zip";
    hash = "sha256-Rup1n14k9sKcyVFYzFqPYV+BEBCnUNwpnFsnyGrhl20=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openarena";
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    name = "openarena-source";
    owner = "OpenArena";
    repo = "engine";
    rev = "075cb860a4d2bc43e75e5f506eba7da877708aba";
    hash = "sha256-ofQKQyS3ti5TSN+zqwPFYuJiB9kvdER6zTWn8yrOpQU=";
  };

  patches = [
    # Fix Makefile `copyFiles` target
    # Related upstream issue: https://github.com/OpenArena/engine/issues/83
    (fetchpatch {
      url = "https://github.com/OpenArena/engine/commit/f2b424bd332e90a1e2592edd21c62bdb8cd05214.patch";
      hash = "sha256-legiXLtZAeG2t1esiBa37qkAgxPJVM7JLhjpxGUmWCo=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    curl
    makeBinaryWrapper
    pkg-config
    which
  ];

  buildInputs = [
    freetype
    libglvnd
    libjpeg
    libogg
    libvorbis
    libxmp
    openal
    SDL2
    speex
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    cp ${./Makefile.local} ./Makefile.local
  '';

  installTargets = [ "copyfiles" ];
  installFlags = [ "COPYDIR=$(out)/share/openarena" ];

  preInstall = ''
    mkdir -p $out/share/openarena
  '';

  postInstall = ''
    install -Dm644 misc/quake3.svg $out/share/icons/hicolor/scalable/apps/openarena.svg

    makeWrapper $out/share/openarena/openarena.* $out/bin/openarena
    makeWrapper $out/share/openarena/oa_ded.* $out/bin/oa_ded

    ln -s ${openarena-maps}/baseoa $out/share/openarena/baseoa
    ln -s ${openarena-maps}/missionpack $out/share/openarena/missionpack
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "OpenArena";
      exec = "openarena";
      icon = "openarena";
      comment = "A fast-paced 3D first-person shooter, similar to id Software Inc.'s Quake III Arena";
      desktopName = "OpenArena";
      categories = [ "Game" "ActionGame" ];
    })
  ];

  meta = {
    description = "A fast-paced 3D first-person shooter, similar to id Software Inc.'s Quake III Arena";
    homepage = "http://openarena.ws/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "openarena";
    maintainers = with lib.maintainers; [ drupol wyvie ];
    platforms = lib.platforms.linux;
  };
})
=======
{ lib, fetchurl, makeWrapper, patchelf, pkgs, stdenv, SDL, libglvnd, libogg, libvorbis, curl, openal }:

stdenv.mkDerivation {
  pname = "openarena";
  version = "0.8.8";

  src = fetchurl {
    name = "openarena.zip";
    url = "http://openarena.ws/request.php?4";
    sha256 = "0jmc1cmdz1rcvqc9ilzib1kilpwap6v0d331l6q53wsibdzsz3ss";
  };

  nativeBuildInputs = [ pkgs.unzip patchelf makeWrapper];

  installPhase = let
    gameDir = "$out/openarena-$version";
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    libPath = lib.makeLibraryPath [ SDL libglvnd libogg libvorbis curl openal ];
    arch = {
      "x86_64-linux" = "x86_64";
      "i386-linux" = "i386";
    }.${stdenv.hostPlatform.system};
  in ''
    mkdir -pv $out/bin
    cd $out
    unzip $src

    patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.${arch}"
    patchelf --set-interpreter "${interpreter}" "${gameDir}/oa_ded.${arch}"

    makeWrapper "${gameDir}/openarena.${arch}" "$out/bin/openarena" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
    makeWrapper "${gameDir}/oa_ded.${arch}" "$out/bin/oa_ded"
  '';

  meta = {
    description = "Crossplatform openarena client";
    homepage = "http://openarena.ws/";
    maintainers = [ lib.maintainers.wyvie ];
    platforms = [ "i386-linux" "x86_64-linux" ];
    license = lib.licenses.gpl2;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
