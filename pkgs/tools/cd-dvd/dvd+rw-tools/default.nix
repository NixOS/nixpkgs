{stdenv, fetchurl, cdrkit, m4}:

stdenv.mkDerivation {
  name = "dvd+rw-tools-7.1";

  src = fetchurl {
    url = http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz;
    sha256 = "1jkjvvnjcyxpql97xjjx0kwvy70kxpiznr2zpjy2hhci5s10zmpq";
  };

  buildInputs = [cdrkit m4];

  preBuild = ''
    makeFlags="prefix=$out"
  '';
  
  # Incompatibility with Linux 2.6.23 headers, see
  # http://www.mail-archive.com/cdwrite@other.debian.org/msg11464.html
  NIX_CFLAGS_COMPILE = "-DINT_MAX=__INT_MAX__";

  meta = {
    homepage = http://fy.chalmers.se/~appro/linux/DVD+RW/tools;
    description = "Tools for burning DVDs";
    platforms = stdenv.lib.platforms.linux;
  };
}
