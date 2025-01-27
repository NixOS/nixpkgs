{
  fetchFromGitHub,
  lib,
  stdenv,
  postgresql,
  buildPostgresqlExtension,
}:
buildPostgresqlExtension rec {
  pname = "system_stats";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "system_stats";
    rev = "v${version}";
    hash = "sha256-/xXnui0S0ZjRw7P8kMAgttHVv8T41aOhM3pM8P0OTig=";
  };

  buildFlags = [ "PG_CFLAGS=-Wno-error=vla" ];

  meta = with lib; {
    description = "A Postgres extension for exposing system metrics such as CPU, memory and disk information";
    homepage = "https://github.com/EnterpriseDB/system_stats";
    changelog = "https://github.com/EnterpriseDB/system_stats/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ shivaraj-bh ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
