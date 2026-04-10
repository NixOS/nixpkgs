{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.14.0";
  zipHash = {
    x86_64-linux = "sha256-+4RoyDRGLgD46FelK9zWfjokiXtgBhEU5RdsGheCEns=";
    aarch64-linux = "sha256-9CJy8Wf/B17T64NyL4SBrmLYecdVYSXA5qnpKhcdAHs=";
    x86_64-darwin = "sha256-ixrSa02vC/MBg29FNmBRd6YvhkL3QZnzOysLLFgjHEA=";
    aarch64-darwin = "sha256-g7ovNQ5jJWcG82EJr6mnc2ijD/Wk6dY3cYhSchZOs5M=";
  };
  meta = {
    description = "Connects Grafana to ClickHouse";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.attrNames zipHash;
  };
}
