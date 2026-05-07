{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "system_stats";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "system_stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+DHfhLBoYdWBvXZVcvnWlNwceTNsQ/irEdgnklv5onA=";
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
