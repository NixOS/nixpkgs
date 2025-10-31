{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.29";
  zipHash = "sha256-YgEMK79KRW3r8rVel+JVf5nWsT1XzYm0L+t5NA2rrdA=";
  meta = with lib; {
    description = "Browse Loki logs without the need for writing complex queries";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
