{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.15.6";
  zipHash = "sha256-2BlR8dKcfevkajT571f2vSn+YOzfrjUaY+dmN0SSZHE=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
