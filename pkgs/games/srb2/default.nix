{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, substituteAll
, cmake
, curl
, nasm
, libopenmpt
, p7zip
, libgme
, libpng
, SDL2
, SDL2_mixer
, zlib
, unzip
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, customAssets ? false
}:

let

  version = "2.2.10";

  # Normal assets found on the official release
  assets = stdenv.mkDerivation rec {
    pname = "srb2-data";
    inherit version;
    nativeBuildInputs = [ unzip ];
    src = fetchurl {
      url = "https://github.com/STJr/SRB2/releases/download/SRB2_release_${version}/SRB2-v${lib.replaceStrings ["."] [""] version}-Full.zip";
      sha256 = "sha256-5prFysyG+F7quhRkSjfK2TL31wMbZniS0vm6m/tDfSU=";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r *pk3 *dta *dat models/ $out/share/srb2/
    '';
  };

  # Custom assets from mazmazz
  mazmazzAssets = stdenv.mkDerivation rec {
    pname = "srb2-mazmazz-data";
    version = "2.2.5";
    nativeBuildInputs = [ p7zip ];
    unpackPhase = let
      mazmazzAssetsPacks = {
        main = fetchurl {
          url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${version}-assets.7z";
          sha256 = "1m9xf3vraq9nipsi09cyvvfa4i37gzfxg970rnqfswd86z9v6v00";
        };
        optional = fetchurl {
          url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${version}-optional-assets.7z";
          sha256 = "1j29jrd0r1k2bb11wyyl6yv9b90s2i6jhrslnh77qkrhrwnwcdz4";
        };
      };
    in ''
      7z x "${mazmazzAssetsPacks.main}"
      7z x "${mazmazzAssetsPacks.optional}"
    '';
    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r * $out/share/srb2
    '';
  };

in stdenv.mkDerivation rec {

  pname = "srb2";
  inherit version;

  chosenAsset = if customAssets then mazmazzAssets else assets;

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "SRB2";
    rev = "SRB2_release_${version}";
    sha256 = "03388n094d2yr5si6ngnggbqhm8b2l0s0qvfnkz49li9bd6a81gg";
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
    "-DSRB2_ASSET_DIRECTORY=${chosenAsset}/share/srb2"
    "-DGME_INCLUDE_DIR=${libgme}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${SDL2.dev}/include/SDL2"
  ];

  # Desktop icon
  desktopItems = [
    (makeDesktopItem rec {
      name = "Sonic Robo Blast 2";
      exec = pname;
      icon = pname;
      comment = meta.description;
      desktopName = name;
      genericName = name;
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/icons

    copyDesktopItems

    cp ../srb2.png $out/share/pixmaps/.
    cp ../srb2.png $out/share/icons/.

    cp bin/lsdlsrb2-${version} $out/bin/srb2
    wrapProgram $out/bin/srb2 --set SRB2WADDIR "${chosenAsset}/share/srb2"
  '';

  meta = with lib; {
    description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zeratax ];
  };
}
