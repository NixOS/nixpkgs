{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_ivm";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "sraoss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HncWX3jx9sEvxGGMMZ9QT4tDQ4JYbkNrFw2aZHgCVE8=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib pg_ivm${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Materialized views with IVM (Incremental View Maintenance) for PostgreSQL";
    homepage = "https://github.com/sraoss/pg_ivm";
    changelog = "https://github.com/sraoss/pg_ivm/releases/tag/v${version}";
    maintainers = with maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
    broken = versionOlder postgresql.version "13";
  };
}
