{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config, nixosTests }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.20.0";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-5w1afLi3Hdfbq/01cdcaS2uZ8uhdjXGvHnNPbYZjXw4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ];
  enableParallelBuilding = true;

  passthru.tests = {
    pgbouncer = nixosTests.pgbouncer;
  };

  meta = with lib; {
    homepage = "https://www.pgbouncer.org/";
    description = "Lightweight connection pooler for PostgreSQL";
    changelog = "https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_${replaceStrings ["."] ["_"] version}";
    license = licenses.isc;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
