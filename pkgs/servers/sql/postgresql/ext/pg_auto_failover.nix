{ stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
  pname = "pg_auto_failover";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "128bfxy7aabyvlcrzdi20f51k9xxgynd76f01v6w1314wrjg2r8f";
  };

  buildInputs = [ postgresql openssl zlib readline ];

  installPhase = ''
    install -D -t $out/bin src/bin/pg_autoctl/pg_autoctl
    install -D -t $out/lib src/monitor/pgautofailover.so
    install -D -t $out/share/postgresql/extension src/monitor/*.sql
    install -D -t $out/share/postgresql/extension src/monitor/pgautofailover.control
  '';

  meta = with stdenv.lib; {
    description = "PostgreSQL extension and service for automated failover and high-availability";
    homepage = "https://github.com/citusdata/pg_auto_failover";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "10";
  };
}
