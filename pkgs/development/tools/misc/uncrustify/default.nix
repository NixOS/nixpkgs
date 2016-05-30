{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.63";

  src = fetchurl {
    url = "mirror://sourceforge/uncrustify/${product}-${version}.tar.gz";
    sha256 = "1qravjzmips3m7asbsd0qllmprrl1rshjlmnfq68w84d38sb3yyz";
  };

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
