{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.11";
  zipHash = "sha256-e0CwwSSH9aqx78d96xy1ntmqb2NpRSEGIGNbVRpwr5E=";
  meta = {
    description = "Developer-friendly incident response for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
