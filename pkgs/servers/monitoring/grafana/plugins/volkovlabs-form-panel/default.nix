{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.3.5";
  zipHash = "sha256-bMqxVx0RiMWKMJ9XM2uQpZr1Fz8EOaCs9WW9hZ3AiFs=";
  meta = {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
