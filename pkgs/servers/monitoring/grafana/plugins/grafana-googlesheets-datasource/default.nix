{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "2.7.1";
  zipHash = {
    x86_64-linux = "sha256-4b/f2sVtno07zv7ZJXvayCjPjzvl6NKs+ezaU9MXoDQ=";
    aarch64-linux = "sha256-pMkYaAQbxjJHd0jg5WRnKgxQCxzlrbepF1GkXa5QmJ4=";
    aarch64-darwin = "sha256-vKatxF27/K7Zi4JtMTFISpWMhV0sx55r8Du6k4WSn+o=";
  };
  meta = {
    description = "Integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
