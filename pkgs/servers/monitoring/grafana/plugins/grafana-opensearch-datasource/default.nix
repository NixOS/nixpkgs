{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.34.4";
  zipHash = {
    x86_64-linux = "sha256-61DfhIEV2VEkZ0cm50+odtw2wVXO3sIvInsZcUzrGGc=";
    aarch64-linux = "sha256-JfYOi13C/ynB+r6aq/dlRmeoWCgYHf2wJUXB9Xa7SVo=";
    aarch64-darwin = "sha256-Y4c3yh1767eASmwr4K428Qv2YsZ/9NIgvF1GFqnQcC4=";
  };
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
