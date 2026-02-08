{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.10";
  zipHash = "sha256-v+LrOESr+eh70eQYWyVF23m/RW1ikSFsJzQhQFh0pZE=";
  meta = {
    description = "Developer-friendly incident response for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
