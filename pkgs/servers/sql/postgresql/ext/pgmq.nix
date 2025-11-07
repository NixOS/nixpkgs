{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgmq";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "tembo-io";
    repo = "pgmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CnXweDsLO2yE+z1tPADqz54Q1rswsKoUVYbdiZFEbPs=";
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
