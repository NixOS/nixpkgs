{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-clickhouse-datasource";
  version = "4.3.2";
  zipHash = {
    x86_64-linux = "sha256-bpsa99dyCgae0T0b0YpnY5PUb1zWeJKufg3zzkpM4n8=";
    aarch64-linux = "sha256-3cHews7A6vTH7YOzr8TFDLnOfG+dlPqHs75uERQSpaU=";
    x86_64-darwin = "sha256-x/Ug9msOGkdia5n7R8blwTMRl+fiIQ03pMib82OyvQU";
    aarch64-darwin = "sha256-2+5SLldZ6EaSbIMtowxoSzmW39tytTUECoDtGP9SfJE=";
  };
  meta = with lib; {
    description = "Connects Grafana to ClickHouse";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ moody ];
    platforms = attrNames zipHash;
  };
}
