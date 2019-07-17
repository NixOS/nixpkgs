{ stdenv, fetchurl, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "pgbouncer-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${name}.tar.gz";
    sha256 = "1m8vsxyna5grs5p0vnxf3fxxnkk9aqjf3qmr2bbkpkhlzr11986q";
  };

  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://pgbouncer.github.io;
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
