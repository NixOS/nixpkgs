{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "system_stats";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "system_stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ANv0JnxX0lG9nrzbfl0HARVxlrFTTJcIK7w8oYLmqKs=";
  };

  buildFlags = [ "PG_CFLAGS=-Wno-error=vla" ];

  meta = {
    description = "Postgres extension for exposing system metrics such as CPU, memory and disk information";
    homepage = "https://github.com/EnterpriseDB/system_stats";
    changelog = "https://github.com/EnterpriseDB/system_stats/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ shivaraj-bh ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
