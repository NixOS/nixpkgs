{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.0.0";
  zipHash = "sha256-oSoprdWcpXypTMM4d3MuPXA/hcqd/3sSxuTluL7JW4Y=";
  meta = {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
