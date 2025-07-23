{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "5.1.0";
  zipHash = "sha256-aFIrKrfcTk4dGBaGVMv6mMLQqys5QaD9XgZIGmtgA5s=";
  meta = with lib; {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
