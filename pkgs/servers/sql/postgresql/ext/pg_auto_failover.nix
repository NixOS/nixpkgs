{ lib, stdenv, fetchFromGitHub, fetchpatch, postgresql, openssl, zlib, readline, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "pg_auto_failover";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hGpcHV4ai9mxaJ/u/o9LNFWPGsW22W7ak2pbvAUgmwU=";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3 support:
    #  https://github.com/citusdata/pg_auto_failover/pull/830
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/citusdata/pg_auto_failover/commit/fc92546965437a6d5f82ed9a6bdc8204a3bca725.patch";
      sha256 = "sha256-t4DC/d/2s/Mc44rpFxBMOWGhACG0s5wAWyeDD7Mefo8=";
    })
  ];

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
