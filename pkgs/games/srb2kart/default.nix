{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, curl
, nasm
, unzip
, game-music-emu
, libpng
, SDL2
, SDL2_mixer
, zlib
, p7zip
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srb2kart";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "Kart-Public";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
  };

  assets = stdenv.mkDerivation {
    pname = "srb2kart-data";
    version = finalAttrs.version;

    nativeBuildInputs = [ p7zip ];

    src = fetchurl {
      url = "https://github.com/STJr/Kart-Public/releases/download/v${finalAttrs.version}/AssetsLinuxOnly.zip";
      sha256 = "sha256-ejhPuZ1C8M9B0S4+2HN1T5pbormT1eVL3nlivqOszdE=";
    };

    unpackPhase = ''
      7z -y x "$src"
    '';

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/srb2kart
      cp -r mdls/ *.kart *.dat *.pdf *.srb $out/share/srb2kart/

      runHook postInstall
    '';
  };

  nativeBuildInputs = [
    cmake
    nasm
    unzip
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    SDL2
    SDL2_mixer
    zlib
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}/share/srb2kart"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  # Desktop icon
  desktopItems = [
    (makeDesktopItem rec {
      name = "Sonic Robo Blast 2 Kart";
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = "Kart racing mod based on SRB2";
      desktopName = name;
      genericName = name;
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/icons

    cp ../srb2.png $out/share/pixmaps/srb2kart.png
    cp ../srb2.png $out/share/icons/srb2kart.png

    cp bin/srb2kart $out/bin/srb2kart
    wrapProgram $out/bin/srb2kart \
      --set SRB2WADDIR "${finalAttrs.assets}/share/srb2kart"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A kart racing mod based on the fangame Sonic Robo Blast 2";
    homepage = "https://mb.srb2.org/addons/srb2kart.2435/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric donovanglover ];
  };
})
