{
  pname,
  version,
  src,
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraMeta ? { },
  compileFlags ? [ ],
  postInstall ? "",
  region ? "us",

  lib,
  stdenv,
  python3,
  pkg-config,
  audiofile,
  SDL2,
  hexdump,
  sm64baserom,
}:
let
  baseRom = (sm64baserom.override { inherit region; }).romPath;
in
stdenv.mkDerivation rec {
  inherit
    pname
    version
    src
    postInstall
    ;

  nativeBuildInputs = [
    python3
    pkg-config
    hexdump
  ] ++ extraNativeBuildInputs;

  buildInputs = [
    audiofile
    SDL2
  ] ++ extraBuildInputs;

  enableParallelBuilding = true;

  makeFlags =
    [
      "VERSION=${region}"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "OSX_BUILD=1"
    ]
    ++ compileFlags;

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s ${baseRom} ./baserom.${region}.z64
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/${region}_pc/sm64.${region}.f3dex2e $out/bin/sm64ex

    runHook postInstall
  '';

  meta =
    with lib;
    {
      longDescription = ''
        ${extraMeta.description or "Super Mario 64 port based off of decompilation"}

        Note that you must supply a baserom yourself to extract assets from.
        If you are not using an US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
        If you would like to use patches sm64ex distributes as makeflags, add them to the "compileFlags" attribute.
      '';
      mainProgram = "sm64ex";
      license = licenses.unfree;
      maintainers = [ ];
      platforms = platforms.unix;
    }
    // extraMeta;
}
