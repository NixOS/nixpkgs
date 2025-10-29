{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.0.3";
  zipHash = "sha256-uGrLxbGNQa82dDhImZHaPAv0GbgV1SwgCHq6q4BjTUs=";
  meta = {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
