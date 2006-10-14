{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "texinfo-4.8a";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/texinfo/texinfo-4.8a.tar.bz2;
    md5 = "0f429f87de9f20d6c0d952e63bf8e3fa";
  };
  buildInputs = [ncurses];
}
