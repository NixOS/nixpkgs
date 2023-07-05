{
  stdenv,
  lib,
  makeWrapper,
  writeScriptBin,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  cmake,
  git,
  glew,
  SDL2,
  zlib,
  minizip,
  libjpeg,
  curl,
  lua,
  libogg,
  libtheora,
  freetype,
  libpng,
  sqlite,
  openal,
  unzip,
  cjson,
}: let
  version = "2.81.1";
  pkgname = "etlegacy";
  mirror = "https://mirror.etlegacy.com";
  fetchAsset = {
    asset,
    sha256,
  }:
    fetchurl
    {
      url = mirror + "/etmain/" + asset;
      inherit sha256;
    };
  pak0 =
    fetchAsset
    {
      asset = "pak0.pk3";
      sha256 = "712966b20e06523fe81419516500e499c86b2b4fec823856ddbd333fcb3d26e5";
    };
  pak1 =
    fetchAsset
    {
      asset = "pak1.pk3";
      sha256 = "5610fd749024405b4425a7ce6397e58187b941d22092ef11d4844b427df53e5d";
    };
  pak2 =
    fetchAsset
    {
      asset = "pak2.pk3";
      sha256 = "a48ab749a1a12ab4d9137286b1f23d642c29da59845b2bafc8f64e052cf06f3e";
    };
  fakeGit = writeScriptBin "git" ''
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      echo "${version}"
    fi
  '';
  mainProgram =
    if stdenv.hostPlatform.system == "i686-linux"
    then "etl.i386"
    else "etl.x86_64";
in
  stdenv.mkDerivation rec {
    pname = pkgname;
    inherit version;

    src = fetchFromGitHub {
      owner = "etlegacy";
      repo = "etlegacy";
      rev = "refs/tags/v" + version;
      sha256 = "sha256-CGXtc51vaId/SHbD34ZeT0gPsrl7p2DEw/Kp+GBZIaA="; # 2.81.1
    };

    nativeBuildInputs = [cmake fakeGit git makeWrapper unzip cjson];
    buildInputs = [
      glew
      SDL2
      zlib
      minizip
      libjpeg
      curl
      lua
      libogg
      libtheora
      freetype
      libpng
      sqlite
      openal
    ];

    preBuild = ''
      # Required for build time to not be in 1980
      export SOURCE_DATE_EPOCH=$(date +%s)
      # This indicates the build was by a CI pipeline and prevents the resource
      # files from being flagged as 'dirty' due to potentially being custom built.
      export CI="true"
    '';

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCROSS_COMPILE32=0"
      "-DBUILD_SERVER=0"
      "-DBUILD_CLIENT=1"
      "-DBUNDLED_JPEG=0"
      "-DBUNDLED_LIBS=0"
      "-DINSTALL_EXTRA=0"
      "-DINSTALL_OMNIBOT=0"
      "-DINSTALL_GEOIP=0"
      "-DINSTALL_WOLFADMIN=0"
      "-DFEATURE_AUTOUPDATE=0"
      "-DINSTALL_DEFAULT_BASEDIR=."
      "-DINSTALL_DEFAULT_BINDIR=."
      "-DINSTALL_DEFAULT_MODDIR=."
    ];

    postInstall = ''
      ETMAIN=$out/etmain
      mkdir -p $ETMAIN
      ln -s ${pak0} $ETMAIN/pak0.pk3
      ln -s ${pak1} $ETMAIN/pak1.pk3
      ln -s ${pak2} $ETMAIN/pak2.pk3
      makeWrapper $out/${mainProgram} $out/bin/${mainProgram} --chdir $out
    '';

    meta = with lib; {
      description = "ET: Legacy is an open source project based on the code of Wolfenstein: Enemy Territory which was released in 2010 under the terms of the GPLv3 license";
      homepage = "https://etlegacy.com";
      platforms = ["i686-linux" "x86_64-linux"];
      license = [licenses.gpl3 licenses.cc-by-nc-sa-30];
      inherit mainProgram;
      maintainers = with maintainers; [ashleyghooper];
    };
  }
