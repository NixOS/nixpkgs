{stdenv, fetchurl, SDL, zlib, alsaLib}:

stdenv.mkDerivation {
  name = "scummvm-0.9.1";
  
  src = fetchurl {
    url = http://ovh.dl.sourceforge.net/sourceforge/scummvm/scummvm-0.9.1.tar.bz2;
    sha256 = "06jxq4lbb0s1axpz0md8cjkx8i8086qgkafrhlfzi941cb0dkmaw";
  };
  
  buildInputs = [SDL zlib alsaLib];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
