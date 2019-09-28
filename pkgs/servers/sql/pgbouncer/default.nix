{ stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.11.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "0w3y53kwnkcm9fmf28zbjvqk6ivfic5f2k3nflvca1i8iaj2z044";
  };

  buildInputs = [ libevent openssl c-ares pkg-config ];

  meta = with stdenv.lib; {
    homepage = https://pgbouncer.github.io;
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
