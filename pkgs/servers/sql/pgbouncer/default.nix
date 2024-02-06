{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config, nixosTests }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.22.0";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-xu43qNfdvrv4RC2PCOwHw9pGr7Kq45ZziMFIFpineFg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  passthru.tests = {
    pgbouncer = nixosTests.pgbouncer;
  };

  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    mainProgram = "pgbouncer";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${replaceStrings ["."] ["_"] version}";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
