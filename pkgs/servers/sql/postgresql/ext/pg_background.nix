{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  openssl,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_background";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "vibhorkum";
    repo = "pg_background";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7lQrNrWpgvW98MomZ0xu3PYf0dnMlvLP3W1e9l49cBI=";
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
