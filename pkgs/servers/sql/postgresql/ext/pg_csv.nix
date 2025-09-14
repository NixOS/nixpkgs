{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_csv";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "PostgREST";
    repo = "pg_csv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sw9eMpzz+suotJQ2KHgT0dQAF8OGFojJIhOC8tZ750o=";
  };

  meta = {
    description = "Flexible CSV processing for Postgres";
    homepage = "https://github.com/PostgREST/pg_csv";
    changelog = "https://github.com/PostgREST/pg_csv/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
