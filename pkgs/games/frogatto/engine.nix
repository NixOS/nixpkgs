{ stdenv, fetchFromGitHub, bash, which
, boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf
, glew, zlib, icu, pkgconfig, cairo, libvpx }:

stdenv.mkDerivation rec {
  pname = "anura-engine";
  version = "unstable-2018-11-28";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    # trunk branch as of 2018-11-28
    rev = "8070111467802dc772c0a6c7806ecd16b0bcdaa9";
    sha256 = "0xbqwfmws69n7iiz17n93h4jiw39cwyf7hxw0qi2c8cccr37b1nr";
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
    homepage = https://github.com/anura-engine/anura;
    description = "Game engine used by Frogatto";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
