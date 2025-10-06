{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.2.0";
  zipHash = "sha256-o7P2hQBHsSd9qZh1QMlzkJtwo8ug+3E0aEofJf1wukk=";
  meta = {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
