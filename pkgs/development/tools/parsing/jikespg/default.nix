{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikespg-1.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/jikes/jikespg-1.3.tar.gz;
    md5 = "eba183713d9ae61a887211be80eeb21f";
  };
}
