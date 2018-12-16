{ stdenv, fetchFromGitHub, bash, which,
  boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf,
  glew, zlib, icu, pkgconfig, cairo, libvpx,
}:

let
  version = "0.0.2018-11-28";
  source = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    fetchSubmodules = true;
    # trunk branch as of 2018-11-28
    rev = "8070111467802dc772c0a6c7806ecd16b0bcdaa9";
    sha256 = "0xbqwfmws69n7iiz17n93h4jiw39cwyf7hxw0qi2c8cccr37b1nr";
  };
in stdenv.mkDerivation {
  name = "anura-${version}";

  src = source;

  buildInputs = [
    bash
    which
    boost
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    glew
    zlib
    icu
    pkgconfig
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
    maintainers = with stdenv.lib.maintainers; [ astro ];
  };
}
