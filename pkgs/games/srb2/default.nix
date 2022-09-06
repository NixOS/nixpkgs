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
, game-music-emu
, libpng
, SDL2
, SDL2_mixer
, zlib
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

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=/build/source/assets"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${SDL2.dev}/include/SDL2"
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
  '';

  meta = with lib; {
    description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zeratax ];
  };
}
