{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-mqtt-datasource";
  version = "1.1.0-beta.3";
  zipHash = {
    x86_64-linux = "sha256-/0hZc0lFV1LXl6532nLJmJ6fJPdRx+sMt7Uep4GTeX0=";
    aarch64-linux = "sha256-KPIa/yYkzbKm4/mB84/DdIsdqfQBOc0+LGxl2GHDVGk=";
    x86_64-darwin = "sha256-7gGw/RCuzHmj/vaIAweXLPqQYAl0EMSXXjPCtjRC4vU=";
    aarch64-darwin = "sha256-i2/lE7QickowFSvHoo7CuaZ1ChFVpsQgZjvuBTQapq4=";
  };
  meta = with lib; {
    description = "Visualize streaming MQTT data from within Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
