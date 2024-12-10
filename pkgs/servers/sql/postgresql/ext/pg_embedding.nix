{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

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
    knownVulnerabilities = [
      "As of Sept 29, 2023, the authors have abandoned the project and strongly encourage using pgvector, which is faster, has more functionality, and is actively maintained: check out the author's instructions to migrate at https://neon.tech/docs/extensions/pg_embedding#migrate-from-pg_embedding-to-pgvector"
    ];
  };
}
