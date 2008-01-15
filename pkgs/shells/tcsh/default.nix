{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "tcsh-6.15.00";
  src = fetchurl {
    url = ftp://ftp.funet.fi/pub/unix/shells/tcsh/tcsh-6.15.00.tar.gz;
    sha256 = "1p5chgvj87m2dv4ci9qf4i81gav0lzr7rkcm320sj62z09ckxa6w";
  };
  buildInputs = [ncurses];
}
