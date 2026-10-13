{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-json-datasource";
  version = "1.4.2";
  zipHash = "sha256-cYFMHE9d8MCbxmCaVu0HZvLbCgOpK/6PLvbzynt+/QQ=";
  meta = {
    description = "Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
