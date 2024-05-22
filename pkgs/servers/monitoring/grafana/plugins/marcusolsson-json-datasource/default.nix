{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-json-datasource";
  version = "1.3.12";
  zipHash = "sha256-tq8/g+59+EhJbJRbwXoLpQANA6/NVddFqKmC7YWgMFo=";
  meta = with lib; {
    description = "The Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
