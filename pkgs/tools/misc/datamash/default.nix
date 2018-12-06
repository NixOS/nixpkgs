{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.3";

  src = fetchurl {
    url = "mirror://gnu/datamash/${name}.tar.gz";
    sha256 = "19jpcv4ryvbz0476d6dgpxpbjkpmih4q84wj06nslls338bm5fzf";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = https://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
