{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://gnu/datamash/${name}.tar.gz";
    sha256 = "06w0pc828qsabmrlh7bc2zwc823xzxy89paaf37f6bipsyrij222";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = http://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
