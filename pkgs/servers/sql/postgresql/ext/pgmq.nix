{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "pgmq";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "tembo-io";
    repo = "pgmq";
    tag = "v${version}";
    hash = "sha256-IU+i6ONPwtgsFKdzya6E+222ualR66gkbb0lDr+7Rb8=";
  };

  sourceRoot = "${src.name}/pgmq-extension";

  dontConfigure = true;

  meta = {
    description = "Lightweight message queue like AWS SQS and RSMQ but on Postgres";
    homepage = "https://tembo.io/pgmq";
    changelog = "https://github.com/tembo-io/pgmq/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ takeda ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
