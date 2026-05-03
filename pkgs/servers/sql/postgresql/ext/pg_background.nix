{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  openssl,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_background";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "vibhorkum";
    repo = "pg_background";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m5mdXTmml6iX4UKcHeN6uMjypLvHasjD5AXzUhvEHdI=";
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
