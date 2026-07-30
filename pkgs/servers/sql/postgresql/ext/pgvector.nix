{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgvector";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uGvp76uGEKVq+UH4zd4yf4RQenL3linf9SO/X+P2GH8=";
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
