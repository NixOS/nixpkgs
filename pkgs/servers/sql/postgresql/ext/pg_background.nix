{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  openssl,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_background";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "vibhorkum";
    repo = "pg_background";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RA4ZI3BmtbwIGX9Gc+QSxh9lNj5jLVZY5RtPgbt7cTM=";
  };

  buildInputs = postgresql.buildInputs;

  meta = {
    description = "Run PostgreSQL Commands in Background Workers";
    homepage = "https://github.com/vibhorkum/pg_background";
    changelog = "https://github.com/vibhorkum/pg_background/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ mkleczek ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl3Only;
  };
})
