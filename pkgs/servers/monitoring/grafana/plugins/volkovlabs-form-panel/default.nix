{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.3.2";
  zipHash = "sha256-RuwZaAqSwMvWN15jz0+r7DuZyrE52zYD8EBffFTQNEg=";
  meta = {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
