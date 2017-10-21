{ stdenv, fetchurl, openssl, readline }:

stdenv.mkDerivation rec {
  name = "socat-1.7.3.2";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "0lcj6zpra33xhgvhmz9l3cqz10v8ybafb8dd1yqkwf1rhy01ymp3";
  };

  buildInputs = [ openssl readline ];

  hardeningEnable = [ "pie" ];

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
