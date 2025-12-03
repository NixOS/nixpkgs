{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.0.4";
  zipHash = "sha256-bBPESByCux0X711UjmT5bQrJDz1BC9+9EGOOJ4jqcj0=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
