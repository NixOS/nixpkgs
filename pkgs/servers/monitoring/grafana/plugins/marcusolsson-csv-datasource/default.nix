{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  version = "1.0.1";
  zipHash = {
    x86_64-linux = "sha256-J9sk/ypwNo7rHRumJr/PV55PN+kYGC7g02yfBTO9csU=";
    aarch64-linux = "sha256-FitFHq3P7MDaw0aAosGodfVddkmVGw3Yc8Veno5eY1s=";
    aarch64-darwin = "sha256-YRFN3lca8r1ZllIIc+6GsNt5Og5R4UVFGvoujHPK3P8=";
  };
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
