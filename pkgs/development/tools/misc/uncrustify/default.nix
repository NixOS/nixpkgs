{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "uncrustify";
  version = "0.61";

  src = fetchurl {
    url = "mirror://sourceforge/uncrustify/${name}-${version}.tar.gz";
    sha256 = "1df0e5a2716e256f0a4993db12f23d10195b3030326fdf2e07f8e6421e172df9";
  };

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
