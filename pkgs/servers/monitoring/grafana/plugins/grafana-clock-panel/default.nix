{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.2.1";
  zipHash = "sha256-NFKfpC6D+fiYTHEhGP0t5qCxJWt0S99gAsbnq4GHrkY=";
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
