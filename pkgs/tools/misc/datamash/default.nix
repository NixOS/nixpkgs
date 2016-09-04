{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://gnu/datamash/${name}.tar.gz";
    sha256 = "1c2bj0jrm4fxkf0ykxkzgyk1l9s0idqm8rbzmk3n9pgldb4arrd9";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = http://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
