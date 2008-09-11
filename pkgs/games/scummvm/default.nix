{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.12.0";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-0.12.0.tar.bz2;
    sha256 = "16g6qgvlq2rp2q53spmc5li5y44aamr1hvz1v4wrdl28nsxs76nv";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
