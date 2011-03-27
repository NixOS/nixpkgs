{stdenv, fetchurl, scons, pkgconfig, SDL, mesa, zlib }:

throw "Still does not build. It needs smpeg"

stdenv.mkDerivation rec {
  name = "battle-tanks-0.9.8083";

  src = fetchurl {
    url = mirror://sourceforge/btanks/btanks-0.9.8083.tar.bz2;
    sha256 = "0ha35kxc8xlbg74wsrbapfgxvcrwy6psjkqi7c6adxs55dmcxliz";
  };

  /* It still does not build */
  buildInputs = [ scons pkgconfig SDL mesa zlib ];

  installPhase = ''
    scons PREFIX=$out
    scons PREFIX=$out install
  '';

  meta = {
    homepage = http://sourceforge.net/projects/btanks/;
    description = "Fast 2d tank arcade game";
    license = "GPLv2+";
  };
}
