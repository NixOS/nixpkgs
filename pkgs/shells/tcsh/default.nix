{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "tcsh-6.14.00";
  src = fetchurl {
    url = ftp://ftp.gw.com/pub/unix/tcsh/tcsh-6.14.00.tar.gz;
    md5 = "353d1bb7d2741bf8de602c7b6f0efd79";
  };
  buildInputs = [ncurses];
}
