{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "volkovlabs-form-panel";
  version = "6.2.0";
  zipHash = "sha256-o7P2hQBHsSd9qZh1QMlzkJtwo8ug+3E0aEofJf1wukk=";
  meta = with lib; {
    description = "Plugin that allows inserting and updating application data, as well as modifying configuration directly from your Grafana dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
