{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "uncrustify-0.60";

  src = fetchurl {
    url = "mirror://sourceforge/uncrustify/${name}.tar.gz";
    sha256 = "1v3wlkh669mfzbyg68xz7c1hj3kj7l6cavbvbj3jr47ickc3wzsa";
  };

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
