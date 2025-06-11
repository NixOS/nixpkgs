{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.8.2";
  zipHash = {
    x86_64-linux = "sha256-gegkpks7KIHKUG3nmNzEulbhH18eOsx8Afr0tprHFkk=";
    aarch64-linux = "sha256-wvde2c+goezC1xFPZZ9MnHEk287E2ScyExKNXDTbcT8=";
    x86_64-darwin = "sha256-zS9LfvSOWCKQIv5GsRS48taM31ZN4i2REY+IIQbqisk=";
    aarch64-darwin = "sha256-0QfTdgOkfs27EW1VB+AgHPwF1GRcFBxMPBZ9nRyovrs=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody ];
    platforms = attrNames zipHash;
  };
}
