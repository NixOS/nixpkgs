{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-mqtt-datasource";
  version = "1.1.0-beta.2";
  zipHash = {
    x86_64-linux = "sha256-QYv+6zDLSYiB767A3ODgZ1HzPd7Hpa90elKDV1+dNx8=";
    aarch64-linux = "sha256-cquaTD3e40vj7PuQDHvODHOpXeWx3AaN6Mv+Vu+ikbI=";
    x86_64-darwin = "sha256-PZmUkghYawU5aKA536u3/LCzsvkIFVJIzl1FVWcrKTI=";
    aarch64-darwin = "sha256-9FP7UbNI4q4nqRTzlNKcEPnJ9mdqzOL4E0nuEAdFNJw=";
  };
  meta = with lib; {
    description = "The MQTT data source plugin allows you to visualize streaming MQTT data from within Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
