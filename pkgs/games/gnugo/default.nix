{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gnugo-${version}";
  version = "3.8";

  src = fetchurl {
    url = "mirror://gnu/gnugo/gnugo-${version}.tar.gz";
    sha256 = "0wkahvqpzq6lzl5r49a4sd4p52frdmphnqsfdv7gdp24bykdfs6s";
  };

  hardeningDisable = [ "format" ];

  meta = {
    description = "GNU Go - A computer go player";
    homepage = http://www.gnu.org/software/gnugo/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
