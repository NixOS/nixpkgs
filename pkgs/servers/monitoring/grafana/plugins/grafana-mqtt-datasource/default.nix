{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.3.7";
  zipHash = {
    x86_64-linux = "sha256-2Ls/OLoPhrp2neEVZeMyUhvsammrgn2xEhyPMEJ9Ueo=";
    aarch64-linux = "sha256-WfWB0gbvylebikD0+haqxW7Q8LxICeZnMMFxRf4bVf0=";
    aarch64-darwin = "sha256-RbtTwYqgKi4rDahRMlCiXIVJIld7jIlK9pQwFAh/Kp4=";
  };
  meta = {
    description = "Visualize streaming MQTT data from within Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
