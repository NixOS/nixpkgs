{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.22";
  zipHash = "sha256-y1WJ1RxUbJSsiSApz3xvrARefNnXdZxDVfzeGfDZbFo=";
  meta = with lib; {
    description = "Browse Loki logs without the need for writing complex queries";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
