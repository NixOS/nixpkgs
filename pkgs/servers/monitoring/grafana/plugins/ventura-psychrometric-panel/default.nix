{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.0.1";
  zipHash = "sha256-WcMgjgDobexUrfZOBmXRWv0FD3us3GgglxRdpo9BecA=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
