{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.6";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1jvqxcyh0aghnqh3m2rk5av1x0038flcmfzd493vasv1k69vgfdr";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
