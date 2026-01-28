{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgmq";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tembo-io";
    repo = "pgmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rgs3iZfnKAijz8mk9A2tM1WuL8uMFYE3IRa+JgWk0LE=";
  };

  sourceRoot = "${finalAttrs.src.name}/pgmq-extension";

  dontConfigure = true;

  meta = {
    description = "Lightweight message queue like AWS SQS and RSMQ but on Postgres";
    homepage = "https://tembo.io/pgmq";
    changelog = "https://github.com/tembo-io/pgmq/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ takeda ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
