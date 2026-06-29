{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.18.0";
  zipHash = {
    x86_64-linux = "sha256-S1clG5WW9ThQ4+F5OYL/GMvv3FMw7p5EfjmyhBhqgrg=";
    aarch64-linux = "sha256-SZuSa6afDmTAf1XK6nZKWr+VRUpymevXrnTjDF0zYqY=";
    x86_64-darwin = "sha256-81INClbBI9p1y/nVyc+uSCAgfJqEbke7F0mGm+H7Q84=";
    aarch64-darwin = "sha256-vTMdhRNgzIPfekR/bsMpD9uOh0suV1WkMY0T3HtSd90=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
