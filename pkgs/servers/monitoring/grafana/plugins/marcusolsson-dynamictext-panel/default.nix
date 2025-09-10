{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-dynamictext-panel";
  version = "6.0.0";
  zipHash = "sha256-OfQWEwEu+c0DvuACddBM5wjXZWxr6D3QP/N4KUQfQ+k=";
  meta = with lib; {
    description = "Dynamic, data-driven text panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.unix;
  };
}
