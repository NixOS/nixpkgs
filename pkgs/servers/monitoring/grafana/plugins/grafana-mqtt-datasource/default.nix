{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.1";
  zipHash = {
    x86_64-linux = "sha256-/a/15VPcRr37QL7ZN5VgTXqioqC9dWMODdigLJTPkr8=";
    aarch64-linux = "sha256-kSzyQkC+fHZVJPA3xBtfDD2i4rszlbu+gCMDbzZmlL0=";
    x86_64-darwin = "sha256-MKMDXsk+5cfohl7Dx4BwjjbPn3aXsQ4d917GmdBkwZI=";
    aarch64-darwin = "sha256-tWNkGZebMTMmoNtB7WevoWIEAYyOcba9PETaLwz8chI=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
