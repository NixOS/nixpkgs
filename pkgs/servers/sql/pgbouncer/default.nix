{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.19.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-WMPv+btywYEzso4fA0/Vk1bqdigcZeEnQyyhAcIIo5Q=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${replaceStrings ["."] ["_"] version}";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
