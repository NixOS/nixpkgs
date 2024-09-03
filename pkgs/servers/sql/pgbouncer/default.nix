{ lib, stdenv, fetchurl, openssl, libevent, c-ares, pkg-config, systemd, nixosTests }:

stdenv.mkDerivation rec {
  pname = "pgbouncer";
  version = "1.23.1";

  src = fetchurl {
    url = "https://www.pgbouncer.org/downloads/files/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-GWO0lyMdmlYKYtJm5KLq5ogatAGFPZPl0pLDdA7sUIQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl c-ares ]
    ++ lib.optional stdenv.isLinux systemd;
  enableParallelBuilding = true;
  configureFlags = lib.optional stdenv.isLinux "--with-systemd";

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
