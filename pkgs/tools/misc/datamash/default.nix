{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.7";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1cxdlhgz3wzjqlq8bgwad93fgqymk2abbldfzw1ffnhcp4mmjjjp";
  };

  meta = with lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
