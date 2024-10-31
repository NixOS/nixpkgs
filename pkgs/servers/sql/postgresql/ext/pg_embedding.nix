{ lib, stdenv, fetchFromGitHub, postgresql, buildPostgresqlExtension }:

buildPostgresqlExtension rec {
  pname = "pg_embedding";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = pname;
    rev = version;
    hash = "sha256-NTBxsQB8mR7e/CWwkCEyDiYhi3Nxl/aKgRBwqc0THcI=";
  };

  meta = with lib; {
    description = "PostgreSQL extension implementing the HNSW algorithm for vector similarity search";
    homepage = "https://github.com/neondatabase/pg_embedding";
    maintainers = with maintainers; [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
