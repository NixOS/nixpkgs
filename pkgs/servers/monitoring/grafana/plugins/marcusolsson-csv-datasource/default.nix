{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  version = "0.8.2";
  zipHash = {
    x86_64-linux = "sha256-iey8/aBEdvlX7l/ZT75dhDM135G0o+HozmFaapVMxvo=";
    aarch64-linux = "sha256-+ceO0fNpBoWVtNNEwy8vppzK+PTWRE3Yk8yyg8eW9xo=";
    x86_64-darwin = "sha256-kvYv/2zgqooordP4Zr0CTmYYfj8upq2L/9XWoBHcYSA=";
    aarch64-darwin = "sha256-0XvHSdvFe0XgyYPuqm75OECGVNNHRaLLdYrNS18ZCu4=";
  };
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
