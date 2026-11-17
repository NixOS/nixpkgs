{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.8";
  zipHash = {
    x86_64-linux = "sha256-4HJyHytpeoU6ru+ohlN5fhvpzNFNuJl9+LzD+bTlm7Q=";
    aarch64-linux = "sha256-62hq0iMGweN4+NydY7N4vntwaq2XHyUNroo9AtDjXK4=";
    aarch64-darwin = "sha256-9XHexZLirctyF4S07GuG4fhMlvn4y8sh8WPOsQ2SB14=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
