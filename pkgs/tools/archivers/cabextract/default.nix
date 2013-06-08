{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cabextract-1.4";

  src = fetchurl {
    url = "http://www.cabextract.org.uk/${name}.tar.gz";
    sha256 = "07p49053a727nwnw7vnx1bpj4xqa43cvx8mads2146fpqai8pfpp";
  };

  meta = {
    homepage = http://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = stdenv.lib.platforms.all;
  };
}
