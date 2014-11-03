{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, zlib, smpeg, SDL_image, libvorbis, lua5, zip }:

stdenv.mkDerivation rec {
  name = "battle-tanks-0.9.8083";

  src = fetchurl {
    url = mirror://sourceforge/btanks/btanks-0.9.8083.tar.bz2;
    sha256 = "0ha35kxc8xlbg74wsrbapfgxvcrwy6psjkqi7c6adxs55dmcxliz";
  };

  buildInputs = [ scons pkgconfig SDL mesa zlib smpeg SDL_image libvorbis lua5
    zip ];

  buildPhase = ''
    scons prefix=$out
  '';

  installPhase = ''
    scons install
  '';

  meta = {
    homepage = http://sourceforge.net/projects/btanks/;
    description = "Fast 2d tank arcade game";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
