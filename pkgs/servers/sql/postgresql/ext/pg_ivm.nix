{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_ivm";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pz9eHmd7GC30r0uUObOlrcdkAX4c+szjYAXS1U999CE=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    maintainers = with maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "13";
  };
}
