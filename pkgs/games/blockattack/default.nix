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
  version = "2.7.0";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "blockattack";
    repo = "blockattack-game";
    rev = "v${version}";
    hash = "sha256-ySLm3AdoJRiMRdla45OJh8ZIFYNh+HzjG2VnFqoWuZA=";
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
