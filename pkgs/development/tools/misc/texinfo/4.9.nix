{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "texinfo-4.9";
  src = fetchurl {
    url = mirror://gnu/texinfo/texinfo-4.9.tar.bz2;
    sha256 = "0h7q9h405m88fjj067brzniiv8306ryl087pgjpmbpd2jci9h6g7";
  };
  buildInputs = [ncurses];
}
