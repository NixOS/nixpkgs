{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "3.1.0";
  zipHash = {
    x86_64-linux = "sha256-x/Uruhk7mhPbsfAcST6tLnxJDd4vlqIkOUI4nAOZN50=";
    aarch64-linux = "sha256-nNAIKoXYyhT1fwSB/a+uD1XUe5RxE9MYrbtHHx6T1fI=";
    x86_64-darwin = "sha256-u9KRR7k/ktMu1KO5tpN/A+x48yDyXXPEnSNEx0hkT8Y=";
    aarch64-darwin = "sha256-ME/LkVXoN1Sp4L3e9qFXgBfa7mCLRyKfEGHiBbaN8iY=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody yuka ];
    platforms = attrNames zipHash;
  };
}
