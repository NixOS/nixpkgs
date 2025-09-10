{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.5";
  zipHash = "sha256-SKekXNYI00M/2f2/iX6+G3B30C1gwpUFa7zzlv8d92Q=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
