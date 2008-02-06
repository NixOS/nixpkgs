{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gzip-1.3.12";
  
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/gzip/gzip-1.3.12.tar.gz;
    sha256 = "1bw7sm68xjlnlzgcx66hnw80ac1qqyvhw0vw27zilgbzbzh5nmiz";
  };

  meta = {
    homepage = http://www.gzip.org/;
    description = "The gzip compression program";
  };
  
  patches = [./gnulib-futimens.patch];
}
