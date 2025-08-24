{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-json-datasource";
  version = "1.3.24";
  zipHash = "sha256-gKFy7T5FQU2OUGBDokNWj0cT4EuOLLMcOFezlArtdww=";
  meta = with lib; {
    description = "Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
