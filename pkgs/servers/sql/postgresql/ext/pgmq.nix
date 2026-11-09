{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgmq";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "pgmq";
    repo = "pgmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-INmTODNrsEiUPNyl22RNmJiX5/GH+ud7orVj26darFk=";
  };

  sourceRoot = "${finalAttrs.src.name}/pgmq-extension";

  dontConfigure = true;

  meta = {
    description = "Lightweight message queue like AWS SQS and RSMQ but on Postgres";
    homepage = "https://tembo.io/pgmq";
    changelog = "https://github.com/pgmq/pgmq/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ takeda ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
