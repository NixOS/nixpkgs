{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-1.1.0";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-1.1.0.tar.bz2;
    sha256 = "0fdqc98jib6593cpjc1jhklp9y0c1mlk0lrn9d6r9ax159x53h2k";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
