{ lib
, stdenv
, fetchurl
, fetchFromGitHub
<<<<<<< HEAD
=======
, substituteAll
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, curl
, nasm
, libopenmpt
, p7zip
, game-music-emu
, libpng
, SDL2
, SDL2_mixer
, zlib
<<<<<<< HEAD
, unzip
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srb2";
  version = "2.2.11";
=======
}:

let

assets_version = "2.2.5";

assets = fetchurl {
  url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${assets_version}-assets.7z";
  sha256 = "1m9xf3vraq9nipsi09cyvvfa4i37gzfxg970rnqfswd86z9v6v00";
};

assets_optional = fetchurl {
  url = "https://github.com/mazmazz/SRB2/releases/download/SRB2_assets_220/srb2-${assets_version}-optional-assets.7z";
  sha256 = "1j29jrd0r1k2bb11wyyl6yv9b90s2i6jhrslnh77qkrhrwnwcdz4";
};

in stdenv.mkDerivation rec {
  pname = "srb2";
  version = "2.2.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "SRB2";
<<<<<<< HEAD
    rev = "SRB2_release_${finalAttrs.version}";
    hash = "sha256-tyiXivJWjNnL+4YynUV6k6iaMs8o9HkHrp+qFj2+qvQ=";
=======
    rev = "SRB2_release_${version}";
    sha256 = "03388n094d2yr5si6ngnggbqhm8b2l0s0qvfnkz49li9bd6a81gg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    nasm
    p7zip
<<<<<<< HEAD
    makeWrapper
    copyDesktopItems
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    libopenmpt
    SDL2
    SDL2_mixer
    zlib
  ];

<<<<<<< HEAD
  assets = stdenv.mkDerivation {
    pname = "srb2-data";
    version = finalAttrs.version;

    nativeBuildInputs = [
      unzip
    ];

    src = fetchurl {
      url = "https://github.com/STJr/SRB2/releases/download/SRB2_release_${finalAttrs.version}/SRB2-v${lib.replaceStrings ["."] [""] finalAttrs.version}-Full.zip";
      hash = "sha256-KsJIkCczD/HyIwEy5dI3zsHbWFCMBaCoCHizfupFoWM=";
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/share/srb2
      cp -r *pk3 *dta *dat models/ $out/share/srb2/
    '';
  };

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}/share/srb2"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2.dev}/include/SDL2"
  ];

  patches = [
    # Fix unknown command "CPMAddPackage" by not using Ccache.cmake
    ./cmake.patch
  ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "Sonic Robo Blast 2";
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = finalAttrs.meta.description;
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

    cp bin/lsdlsrb2 $out/bin/srb2
    wrapProgram $out/bin/srb2 --set SRB2WADDIR "${finalAttrs.assets}/share/srb2"
=======
  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=/build/source/assets"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  patches = [
    ./wadlocation.patch
  ];

  postPatch = ''
    substituteInPlace src/sdl/i_system.c \
        --replace '@wadlocation@' $out
  '';

  preConfigure = ''
    7z x ${assets} -o"/build/source/assets" -aos
    7z x ${assets_optional} -o"/build/source/assets" -aos
  '';

  postInstall = ''
    mkdir $out/bin
    mv $out/lsdlsrb2-${version} $out/bin/srb2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ zeratax donovanglover ];
  };
})
=======
    maintainers = with maintainers; [ zeratax ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
