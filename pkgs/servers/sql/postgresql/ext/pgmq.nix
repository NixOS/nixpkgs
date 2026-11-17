{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgmq";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "pgmq";
    repo = "pgmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/L/ic6WZ64Uc6JDNnKGVFVpQa2a+3OGIeyQwPFTJ5U=";
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
