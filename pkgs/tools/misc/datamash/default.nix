{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.4";

  src = fetchurl {
    url = "mirror://gnu/datamash/${name}.tar.gz";
    sha256 = "fa44dd2d5456bcb94ef49dfc6cfe62c83fd53ac435119a85d34e6812f6e6472a";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = https://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
