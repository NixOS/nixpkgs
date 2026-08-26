{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-clock-panel";
  version = "3.2.3";
  zipHash = "sha256-qNX6LTg+WKjoJIWX7Mc2IRnWVpoZZsiZQzQqR2u1Q10=";
  meta = {
    description = "Clock panel for Grafana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
}
