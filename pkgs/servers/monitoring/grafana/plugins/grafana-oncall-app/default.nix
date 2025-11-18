{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.6";
  zipHash = "sha256-n5V3CkTLXKKmyz12/UbYWIksSC9+EBj3/V4y+H5jyUE=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
