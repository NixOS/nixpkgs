{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.3.0";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "011ydc0x8camplf8l6mshs3v5fswarld8v0wf7grz6rjq18fhrq7";
  };

  buildInputs = [ openssl ];

  patches = [ ./enable-ecdhe.patch ];

  preConfigure = ''
    export CFLAGS="-fPIE -fstack-protector-all --param ssp-buffer-size=4 -O2 -D_FORTIFY_SOURCE=2"
    export LDFLAGS="-pie -Wl,-z,relro,-z,now"
  '';

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
