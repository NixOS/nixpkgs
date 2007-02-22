{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "autoconf-2.61";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/autoconf/autoconf-2.61.tar.bz2;
    md5 = "36d3fe706ad0950f1be10c46a429efe0";
  };
  buildInputs = [m4 perl];
}
