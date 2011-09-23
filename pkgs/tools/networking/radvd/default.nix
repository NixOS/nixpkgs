{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "radvd-1.8.1";
  
  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.gz";
    sha256 = "1sg3halppbz3vwr88lbcdv7mndzwl4nkqnrafkyf2a248wwz2cbc";
  };

  buildInputs = [ bison flex ];

  meta.homepage = http://www.litech.org/radvd/;
  meta.description = "IPv6 Router Advertisement Daemon";
  meta.platforms = stdenv.lib.platforms.linux;
}
