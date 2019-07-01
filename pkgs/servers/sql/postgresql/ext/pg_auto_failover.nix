{ stdenv, fetchFromGitHub, postgresql, openssl }:

if stdenv.lib.versionOlder postgresql.version "10"
then throw "pg_auto_failover not supported for PostgreSQL ${postgresql.version}"
else
stdenv.mkDerivation rec {
  pname = "pg_auto_failover";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "1296zk143y9fvmcg2hjbrjdjfhi5rrd0clh16vblkghcvxrzfyvy";
  };

  buildInputs = [ postgresql openssl ];

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
  };
}
