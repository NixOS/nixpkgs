{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.3.1";
  zipHash = "sha256-HuzhTWey/6xLu6GPXGnN4/D3rs7yJ2sPGzO8PPuZmNA=";
  meta = with lib; {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
