{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.17.0";

  src = fetchurl {
    url = "https://pgbouncer.github.io/downloads/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-ZXMJt7xceoXL9wqaRBtTX3gkEjCB6rt7qG0ANJolbiM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://pgbouncer.github.io";
    description = "Lightweight connection pooler for PostgreSQL";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
