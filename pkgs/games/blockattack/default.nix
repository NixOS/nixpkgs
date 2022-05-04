{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, boost
, cmake
, gettext
, physfs
, pkg-config
, zip
}:

stdenv.mkDerivation rec {
  pname = "blockattack";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "blockattack";
    repo = "blockattack-game";
    rev = "v${version}";
    hash = "sha256-2oKesdr2eNZhDlGrFRiH5/8APFkGJfxPCNvzFoIumdQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    zip
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL2_ttf
    boost
    physfs
  ];

  preConfigure = ''
    patchShebangs packdata.sh source/misc/translation/*.sh
    chmod +x ./packdata.sh
    ./packdata.sh
  '';

  meta = with lib; {
    homepage = "https://blockattack.net/";
    description = "An open source clone of Panel de Pon (aka Tetris Attack)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
