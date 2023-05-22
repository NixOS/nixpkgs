{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  curl,
  nasm,
  libopenmpt,
  p7zip,
  libgme,
  libpng,
  SDL2,
  SDL2_mixer,
  zlib,
  unzip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}: let
  version = "2.2.11";

  assets = stdenv.mkDerivation rec {
    pname = "srb2-data";
    inherit version;
    nativeBuildInputs = [unzip];
    src = fetchurl {
      url = "https://github.com/STJr/SRB2/releases/download/SRB2_release_${version}/SRB2-v${lib.replaceStrings ["."] [""] version}-Full.zip";
      sha256 = "sha256-KsJIkCczD/HyIwEy5dI3zsHbWFCMBaCoCHizfupFoWM=";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r *pk3 *dta *dat models/ $out/share/srb2/
    '';
  };
in
  stdenv.mkDerivation rec {
    pname = "srb2";
    inherit version;

    src = fetchFromGitHub {
      owner = "STJr";
      repo = "SRB2";
      rev = "SRB2_release_${version}";
      sha256 = "sha256-tyiXivJWjNnL+4YynUV6k6iaMs8o9HkHrp+qFj2+qvQ=";
    };

    nativeBuildInputs = [
      cmake
      nasm
      p7zip
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      curl
      libgme
      libpng
      libopenmpt
      SDL2
      SDL2_mixer
      zlib
    ];

    cmakeFlags = [
      "-DSRB2_ASSET_DIRECTORY=${assets}/share/srb2"
      "-DGME_INCLUDE_DIR=${libgme}/include"
      "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
      "-DSDL2_MIXER_INCLUDE_DIR=${SDL2_mixer.dev}/include/SDL2"
      "-DSDL2_INCLUDE_DIR=${SDL2.dev}/include/SDL2"
    ];

    desktopItems = [
      (makeDesktopItem rec {
        name = "Sonic Robo Blast 2";
        exec = pname;
        icon = pname;
        comment = meta.description;
        desktopName = name;
        genericName = name;
        categories = ["Game"];
      })
    ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/icons

      copyDesktopItems

      cp ../srb2.png $out/share/pixmaps/.
      cp ../srb2.png $out/share/icons/.

      cp bin/lsdlsrb2-${version} $out/bin/srb2
      wrapProgram $out/bin/srb2 --set SRB2WADDIR "${assets}/share/srb2"
    '';

    meta = with lib; {
      description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
      homepage = "https://www.srb2.org/";
      platforms = platforms.linux;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [zeratax];
    };
  }
