{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.0.2";
  zipHash = "sha256-375akpkIh4aB2N0T+O++VKmQkuVVMpn8V1/wugbzThU=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
