{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.13.0";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-0.13.0.tar.bz2;
    sha256 = "0b82gpm596zggnm9d3gzji4xa12w1gbzariqi9hvk8mifpz6fliy";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
