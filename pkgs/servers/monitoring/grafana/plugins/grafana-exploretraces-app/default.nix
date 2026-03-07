{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
  version = "1.3.3";
  zipHash = "sha256-J3fPZy6y0B0vRpc2Cvvc8JN+Df1EDR3iNjvK/fJqzac=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
