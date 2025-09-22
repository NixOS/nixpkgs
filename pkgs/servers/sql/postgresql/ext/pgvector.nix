{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgvector";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4EqazYWstczL9T3YFqq2gtbcKIj6zWU8ItYt2nnwPYo=";
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
