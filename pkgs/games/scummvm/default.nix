{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-1.1.1";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-1.1.1.tar.bz2;
    sha256 = "0jlxwd8rzk4dn221v9w024w6f503am29hd8djzs1vz0bd72nbj4w";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
