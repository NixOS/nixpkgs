{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.13.1";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-0.13.1.tar.bz2;
    sha256 = "1nd089673w775xs6hk9z780l18a008z0srli3cf16aq2a8rh1s23";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
