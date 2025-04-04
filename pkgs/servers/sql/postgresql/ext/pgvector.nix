{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pgvector";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    tag = "v${version}";
    hash = "sha256-JsZV+I4eRMypXTjGmjCtMBXDVpqTIPHQa28ogXncE/Q=";
  };

  meta = {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ ];
  };
}
