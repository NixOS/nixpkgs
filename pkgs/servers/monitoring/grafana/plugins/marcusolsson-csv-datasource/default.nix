{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  version = "1.0.3";
  zipHash = {
    x86_64-linux = "sha256-bomnTVQQWZgafpDhdUB/gQsxP2PB3k2GhNfA9oyd8gg=";
    aarch64-linux = "sha256-quKr40/obq2IVyTUwrB9RvlPDOKEq0IulPMsvslXCUQ=";
    aarch64-darwin = "sha256-b/pl8sGB1VbQ+cdh4qzLFiR80eBYbQb4XeiHfxqZ/0k=";
  };
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
