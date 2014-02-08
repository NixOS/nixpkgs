{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.2.3";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "1l5ajqwfpxy35mvqlihzncmfngn61k7in51wkvd8q4vvmxaar605";
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
