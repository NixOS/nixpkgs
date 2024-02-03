{ lib
, stdenv
, fetchurl
, fetchFromGitHub
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
, unzip
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srb2";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "SRB2";
    rev = "SRB2_release_${finalAttrs.version}";
    hash = "sha256-OSkkjCz7ZW5+0vh6l7+TpnHLzXmd/5QvTidRQSHJYX8=";
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
    game-music-emu
    libpng
    libopenmpt
    SDL2
    SDL2_mixer
    zlib
  ];

  assets = stdenv.mkDerivation {
    pname = "srb2-data";
    version = finalAttrs.version;

    nativeBuildInputs = [
      unzip
    ];

    src = fetchurl {
      url = "https://github.com/STJr/SRB2/releases/download/SRB2_release_${finalAttrs.version}/SRB2-v${lib.replaceStrings ["."] [""] finalAttrs.version}-Full.zip";
      hash = "sha256-g7kaNRE1tjcF5J2v+kTnrDzz4zs5f1b/NH67ce2ifUo=";
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
    # Make the build work without internet connectivity
    # See: https://build.opensuse.org/request/show/1109889
    ./cmake.patch
    ./thirdparty.patch
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
  '';

  meta = with lib; {
    description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zeratax donovanglover ];
    mainProgram = "srb2";
  };
})
