{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.11.1";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-0.11.1.tar.bz2;
    sha256 = "13m5a7v6ssp0l666d2p2zscqwh0cf36cgqns16cv5135wsqw4n88";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
