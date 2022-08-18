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
, customAssets ? false
}:

let

  # Common info
  mainName = "srb2";
  version = "2.2.10";
  owner = "STJr";
  repo = "SRB2";
  fixVersion = builtins.replaceStrings ["."] [""] version;
  description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";

  # Normal assets found on the official release
  assets = stdenv.mkDerivation rec {
    pname = "${mainName}-data";
    inherit version;
    nativeBuildInputs = [ unzip ];
    buildInputs = [ unzip ];
    src = fetchurl {
      url = "https://github.com/${owner}/${repo}/releases/download/${repo}_release_${version}/${repo}-v${fixVersion}-Full.zip";
      sha256 = "sha256-5prFysyG+F7quhRkSjfK2TL31wMbZniS0vm6m/tDfSU=";
    };
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r *pk3 *dta *dat models/ $out/share/srb2/
    '';
  };

  # Custom assets from mazmazz
  mVersion = "2.2.5";
  mAssets = {
    main = fetchurl {
      url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${mVersion}-assets.7z";
      sha256 = "1m9xf3vraq9nipsi09cyvvfa4i37gzfxg970rnqfswd86z9v6v00";
    };
    optional = fetchurl {
      url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${mVersion}-optional-assets.7z";
      sha256 = "1j29jrd0r1k2bb11wyyl6yv9b90s2i6jhrslnh77qkrhrwnwcdz4";
    };
  };
  mazmazzAssets = stdenv.mkDerivation rec {
    pname = "${mainName}-mazmazz-data";
    version = mVersion;
    nativeBuildInputs = [ p7zip ];
    buildInputs = [ p7zip ];
    srcs = [ mAssets.main mAssets.optional ];
    unpackPhase = ''
      7z x "${mAssets.main}"
      7z x "${mAssets.optional}"
    '';
    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r * $out/share/srb2
    '';
  };

in stdenv.mkDerivation rec {

  pname = mainName;
  inherit version;

  chosenAsset = if customAssets then mazmazzAssets else assets;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "SRB2_release_${version}";
    sha256 = "03388n094d2yr5si6ngnggbqhm8b2l0s0qvfnkz49li9bd6a81gg";
  };

  nativeBuildInputs = [
    cmake
    nasm
    p7zip
  ];

  buildInputs = [
    curl
    libgme
    libpng
    libopenmpt
    SDL2
    SDL2_mixer
    zlib
    makeWrapper
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${chosenAsset}/share/srb2"
    "-DGME_INCLUDE_DIR=${libgme}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${SDL2.dev}/include/SDL2"
  ];

  # Desktop icon
  desktopLink = makeDesktopItem rec {
    name = "Sonic Robo Blast 2";
    exec = mainName;
    icon = mainName;
    comment = description;
    desktopName = name;
    genericName = name;
    categories = [ "Game" ];
  };

  installPhase = ''
    mkdir -p $out/bin $out/share $out/share/applications $out/share/pixmaps $out/share/icons

    ln -s ${desktopLink}/share/applications/* $out/share/applications

    cp /build/source/srb2.png $out/share/pixmaps/.
    cp /build/source/srb2.png $out/share/icons/.

    cp bin/lsdlsrb2-${version} $out/bin/srb2
    wrapProgram $out/bin/srb2 --set SRB2WADDIR "${chosenAsset}/share/srb2"
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zeratax ];
  };

}
