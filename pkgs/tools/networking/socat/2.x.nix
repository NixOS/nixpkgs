{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-2.0.0-b6";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "03n70v7ygsl4ji7rwvyv8f70d3q32jnas26j29amkf3fm4agnhvz";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = stdenv.lib.maintainers.eelco;
  };
}
