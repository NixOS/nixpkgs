{ stdenv, fetchFromGitHub, which
, boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf
, glew, zlib, icu, pkgconfig, cairo, libvpx }:

stdenv.mkDerivation {
  pname = "anura-engine";
  version = "unstable-2018-11-28";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    # trunk branch as of 2018-11-28
    rev = "a05f413f255d2854019134be817c253a03da3d9f";
    sha256 = "1hd57q8gbn1zdpibnqd3ma0z1ycayc2f4r9j4m2m9kc6yf4v7w7b";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    which pkgconfig
  ];

  buildInputs = [
    boost
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    glew
    zlib
    icu
    cairo
    libvpx
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/frogatto
    cp -ar data images modules $out/share/frogatto/
    cp -a anura $out/bin/frogatto
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/anura-engine/anura";
    description = "Game engine used by Frogatto";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
