{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.0.7";

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/datamash/${name}.tar.gz";
    sha256 = "0y49zaadzirghy4xfajvsv1f5x805cjp61z212ggipx5243302qs";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = http://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };

}
