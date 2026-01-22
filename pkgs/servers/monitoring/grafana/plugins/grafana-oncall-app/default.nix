{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.9";
  zipHash = "sha256-qAcDKmOGuU7ZyO5wI13xODJ7KazeCnA9v3AC+i9Eq7w=";
  meta = {
    description = "Developer-friendly incident response for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
