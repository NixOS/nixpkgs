{
  stdenv,
  lib,
  makeWrapper,
  writeScriptBin,
  fetchFromGitHub,
  fetchurl,
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

  fetchAsset = { asset, hash }: fetchurl {
    url = "https://mirror.etlegacy.com/etmain/${asset}";
    inherit hash;
  };

  pak0 = fetchAsset {
    asset = "pak0.pk3";
    hash = "sha256-cSlmsg4GUj/oFBlRZQDkmchrK0/sgjhW3b0zP8s9JuU=";
  };

  pak1 = fetchAsset {
    asset = "pak1.pk3";
    hash = "sha256-VhD9dJAkQFtEJafOY5flgYe5QdIgku8R1IRLQn31Pl0=";
  };

  pak2 = fetchAsset {
    asset = "pak2.pk3";
    hash = "sha256-pIq3SaGhKrTZE3KGsfI9ZCwp2lmEWyuvyPZOBSzwbz4=";
  };

  fakeGit = writeScriptBin "git" ''
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      echo "${version}"
    fi
  '';
in
  stdenv.mkDerivation {
    pname = "etlegacy";
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
      "-DBUILD_SERVER=1"
      "-DBUILD_CLIENT=1"
      "-DBUNDLED_JPEG=0"
      "-DBUNDLED_LIBS=0"
      "-DINSTALL_EXTRA=0"
      "-DINSTALL_OMNIBOT=0"
      "-DINSTALL_GEOIP=0"
      "-DINSTALL_WOLFADMIN=0"
      "-DFEATURE_AUTOUPDATE=0"
      "-DINSTALL_DEFAULT_BASEDIR=${placeholder "out"}/lib/etlegacy"
      "-DINSTALL_DEFAULT_BINDIR=${placeholder "out"}/bin"
    ];

    postInstall = ''
      ETMAIN=$out/lib/etlegacy/etmain
      mkdir -p $ETMAIN
      ln -s ${pak0} $ETMAIN/pak0.pk3
      ln -s ${pak1} $ETMAIN/pak1.pk3
      ln -s ${pak2} $ETMAIN/pak2.pk3
      makeWrapper $out/bin/etl.* $out/bin/etl
      makeWrapper $out/bin/etlded.* $out/bin/etlded
    '';

    hardeningDisable = [ "fortify" ];

    meta = with lib; {
      description = "ET: Legacy is an open source project based on the code of Wolfenstein: Enemy Territory which was released in 2010 under the terms of the GPLv3 license";
      homepage = "https://etlegacy.com";
      platforms = ["i686-linux" "x86_64-linux"];
      license = [licenses.gpl3 licenses.cc-by-nc-sa-30];
      mainProgram = "etl";
      maintainers = with maintainers; [ashleyghooper drupol];
    };
  }
