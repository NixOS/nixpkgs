{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-etl+jH72Ft0DqlvWeuJMSIJy2z59H1d0FhwYt18p9v0=";
  };

  meta = with lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      pSub
      vrthra
    ];
  };

}
