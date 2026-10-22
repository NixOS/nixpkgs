{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "2.7.0";
  zipHash = {
    x86_64-linux = "sha256-HN3ybfgZ06TQxPD6bdEV383qiE+eF4NLaR5sZJKiqPQ=";
    aarch64-linux = "sha256-BK2Pkx3a2s+TDWD6C5jfTx5S2ZiYsggQ7CHFukSgt3c=";
    aarch64-darwin = "sha256-UjNigxryZtCNVusSw1P05LAsqD6Njw0q7JvZWnAhzAU=";
  };
  meta = {
    description = "Integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
