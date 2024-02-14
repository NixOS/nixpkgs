{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-form-panel";
  version = "3.6.0";
  zipHash = "sha256-XEqT3o8gAyzQrSEAKget9Nwk5cmj7bV9C8yHvG9b14k=";
  meta = with lib; {
    description = "The Data Manipulation Panel is the first plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
