{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
