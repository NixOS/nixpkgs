{ stdenv, fetchurl }:

let

    versionNumber = "3.8";

in

stdenv.mkDerivation {

  name = "gnugo-${versionNumber}";

  src = fetchurl {
    url = "mirror://gnu/gnugo/gnugo-${versionNumber}.tar.gz";
    sha256 = "0wkahvqpzq6lzl5r49a4sd4p52frdmphnqsfdv7gdp24bykdfs6s";
  };

  meta = {
    description = "GNU Go - A computer go player";
    homepage = "http://http://www.gnu.org/software/gnugo/";
    license = stdenv.lib.licenses.gpl3;
  };

}
