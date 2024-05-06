{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "volkovlabs-form-panel";
  version = "4.6.0";
  zipHash = "sha256-ne2dfCr+PBodeaxGfZL0VrAxHLYEAaeQfuZQf2F3s0s=";
  meta = with lib; {
    description = "The Data Manipulation Panel is the first plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
