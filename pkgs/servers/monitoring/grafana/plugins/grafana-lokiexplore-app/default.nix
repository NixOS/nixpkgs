{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-lokiexplore-app";
  version = "1.0.32";
  zipHash = "sha256-5opNBlHytecVVs9DR7s6pvEo3N+KGGvpCqrAQ8oKwFQ=";
  meta = with lib; {
    description = "Browse Loki logs without the need for writing complex queries";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
