{ stdenv, fetchurl, which, bison, flex }:

stdenv.mkDerivation {
  name = "dictd-1.9.15";

  src = fetchurl {
    url = mirror://sourceforge/dict/dictd-1.9.15.tar.gz;
    sha256 = "0p41yf72l0igmshz6vxy3hm51z25600vrnb9j2jpgws4c03fqnac";
  };

  buildInputs = [ flex bison which ];
  
  configureFlags = "--datadir=/var/run/current-system/share/dictd";

  meta = {
    description = "Dict protocol server and client";
  };
}
