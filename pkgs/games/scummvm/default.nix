{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.10.0";
  
  src = fetchurl {
    url = http://dfn.dl.sourceforge.net/sourceforge/scummvm/scummvm-0.10.0.tar.bz2;
    sha256 = "09ii4vbs4nygc0x4n1l9dkfiywj5qwxv9j81pbrf9r6d6y4wdlf9";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
