{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.18.0";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-k0nJ5Z9viBVjVPT2ryfNsBSiNbAK4YTLqjdoi9DfVEw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
