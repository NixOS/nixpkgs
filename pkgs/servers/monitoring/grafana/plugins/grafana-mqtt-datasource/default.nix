{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.3";
  zipHash = {
    x86_64-linux = "sha256-uJbG8C8ggvlZIRC++KVL/psU/a0s8PMsgTph2F7a+XE=";
    aarch64-linux = "sha256-UndB+T++ega5Gg4hIMXPP0zQyWed4s5DY8nu4J8QuUw=";
    x86_64-darwin = "sha256-alrPXVaxjspRF2CzfBaK9J/0IllKHvm+O5FVEK9xubc=";
    aarch64-darwin = "sha256-qoc2DK7/7WhX0tJ0K/BLojZxbMm1A/1Ibv7EfrRB50Y=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
