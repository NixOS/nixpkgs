{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.1.0";
  zipHash = "sha256-FMoWOXyMZoVU9b2iG81RbEldrr5Hb3WaWIwzXn7qn4A=";
  meta = {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
