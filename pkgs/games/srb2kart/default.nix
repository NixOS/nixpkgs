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

<<<<<<< HEAD
  release_tag = "v1.6";

  assets = fetchurl {
    url = "https://github.com/STJr/Kart-Public/releases/download/${release_tag}/AssetsLinuxOnly.zip";
    sha256 = "sha256-ejhPuZ1C8M9B0S4+2HN1T5pbormT1eVL3nlivqOszdE=";
  };

in stdenv.mkDerivation {
  pname = "srb2kart";
  version = "1.6.0";
=======
release_tag = "v1.3";

installer = fetchurl {
  url = "https://github.com/STJr/Kart-Public/releases/download/${release_tag}/srb2kart-v13-Installer.exe";
  sha256 = "0bk36y7wf6xfdg6j0b8qvk8671hagikzdp5nlfqg478zrj0qf6cs";
};

in stdenv.mkDerivation rec {
  pname = "srb2kart";
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "Kart-Public";
    rev = release_tag;
<<<<<<< HEAD
    sha256 = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
=======
    sha256 = "131g9bmc9ihvz0klsc3yzd0pnkhx3mz1vzm8y7nrrsgdz5278y49";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    #"-DSRB2_ASSET_DIRECTORY=/build/source/assets"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    unzip ${assets} "*.kart" srb2.srb
=======
    unzip ${installer} "*.kart" srb2.srb
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
