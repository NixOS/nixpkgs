{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgvector";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYXz8zqiuqYWpJwImAhMry/QTLHKOP5MzuY0Of+aflc=";
  };

  meta = {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ ];
  };
})
