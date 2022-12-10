{ lib, stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "pg_auto_failover";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CLtLOzKRB9p6+SytMvWCYo7m7s/d+clAGOa2sWi6uZ0=";
  };

  buildInputs = [ postgresql openssl zlib readline libkrb5 ];

  installPhase = ''
    install -D -t $out/bin src/bin/pg_autoctl/pg_autoctl
    install -D -t $out/lib src/monitor/pgautofailover.so
    install -D -t $out/share/postgresql/extension src/monitor/*.sql
    install -D -t $out/share/postgresql/extension src/monitor/pgautofailover.control
  '';

  meta = with lib; {
    description = "PostgreSQL extension and service for automated failover and high-availability";
    homepage = "https://github.com/citusdata/pg_auto_failover";
    changelog = "https://github.com/citusdata/pg_auto_failover/raw/v${version}/CHANGELOG.md";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "10";
  };
}
