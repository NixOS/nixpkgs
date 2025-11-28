{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.31";
  zipHash = "sha256-IFt2w4DYgxYw86XngS8xfSAMqMdbf3fxml/KwGB8lLY=";
  meta = with lib; {
    description = "Browse Loki logs without the need for writing complex queries";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
