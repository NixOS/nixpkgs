{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.2.1";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "0xw2qmmixv7jwsrgx2vy54bq695d6my3pm3z4dcpmf9vqvb2xsps";
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
