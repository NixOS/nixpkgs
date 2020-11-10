{ stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
  pname = "pg_auto_failover";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q5gy1jaklk885xjda9dhf6jd5q3sc7jd8p1zdlwv4srxf6sgf10";
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
