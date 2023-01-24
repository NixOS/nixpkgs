{ lib
, stdenv
, fetchurl
, SDL
, SDL_image
, SDL_mixer
}:

stdenv.mkDerivation rec {
  pname = "vectoroids";
  version = "1.1.0";

  src = fetchurl {
    url = "ftp://ftp.tuxpaint.org/unix/x/vectoroids/src/vectoroids-${version}.tar.gz";
    sha256 = "0bkvd4a1v496w0vlvqyi1a6p25ssgpkchxxxi8899sb72wlds54d";
  };

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
  ];

  preConfigure = ''
    sed -i s,/usr/local,$out, Makefile
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "http://www.newbreedsoftware.com/vectoroids/";
    description = "Clone of the classic arcade game Asteroids by Atari";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
