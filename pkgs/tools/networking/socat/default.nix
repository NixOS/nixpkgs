{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.2.4";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "028yjka2zr6j1i8pmfmvzqki8ajczdl1hnry1x31xbbg3j83jxsb";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = stdenv.lib.maintainers.eelco;
  };
}
