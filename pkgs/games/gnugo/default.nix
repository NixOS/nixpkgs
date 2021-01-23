{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gnugo";
  version = "3.8";

  src = fetchurl {
    url = "mirror://gnu/gnugo/gnugo-${version}.tar.gz";
    sha256 = "0wkahvqpzq6lzl5r49a4sd4p52frdmphnqsfdv7gdp24bykdfs6s";
  };

  hardeningDisable = [ "format" ];

  meta = {
    description = "GNU Go - A computer go player";
    homepage = "https://www.gnu.org/software/gnugo/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
