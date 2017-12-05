{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.2";

  src = fetchurl {
    url = "mirror://gnu/datamash/${name}.tar.gz";
    sha256 = "15jrv3ly0vgvwwi2qjmhi39n7wrklwifdk961wwfaxyc5jr6zm78";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = http://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
