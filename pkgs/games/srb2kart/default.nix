{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, substituteAll
, cmake
, curl
, nasm
, unzip
, game-music-emu
, libpng
, SDL2
, SDL2_mixer
, zlib
}:

let

  release_tag = "v1.6";

  assets = fetchurl {
    url = "https://github.com/STJr/Kart-Public/releases/download/${release_tag}/AssetsLinuxOnly.zip";
    sha256 = "sha256-ejhPuZ1C8M9B0S4+2HN1T5pbormT1eVL3nlivqOszdE=";
  };

in stdenv.mkDerivation {
  pname = "srb2kart";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "Kart-Public";
    rev = release_tag;
    sha256 = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    unzip
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
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
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
    mkdir assets/installer
    pushd assets/installer
    unzip ${assets} "*.kart" srb2.srb
    popd
  '';

  postInstall = ''
    mkdir -p $out/bin $out/share/games/SRB2Kart
    mv $out/srb2kart* $out/bin/
    mv $out/*.kart $out/share/games/SRB2Kart
  '';

  meta = with lib; {
    description = "SRB2Kart is a classic styled kart racer";
    homepage = "https://mb.srb2.org/threads/srb2kart.25868/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
  };
}
