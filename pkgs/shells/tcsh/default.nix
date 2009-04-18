{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "tcsh-6.16.00";
  src = fetchurl {
    url = ftp://ftp.funet.fi/pub/unix/shells/tcsh/tcsh-6.16.00.tar.gz;
    sha256 = "1m0p8lqqna3vpf2k4x3hia3rlrz38av67x7hb4qsiq2kfpbbh0vn";
  };
  buildInputs = [ncurses];
}
