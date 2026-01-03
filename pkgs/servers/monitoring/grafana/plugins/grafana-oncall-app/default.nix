{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.7";
  zipHash = "sha256-bfMp4IzLo4W/5+ZmHabgTqpN4MpF+rJ+uVUvANmzcLo=";
  meta = {
    description = "Developer-friendly incident response for Grafana";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
  };
}
