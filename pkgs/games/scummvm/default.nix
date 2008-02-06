{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-0.11.0";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-0.11.0.tar.bz2;
    sha256 = "106vcknkr07m17rxypavlz3cjyd862bwq1qw1arakcvhhi90mbfl";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
