{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafadruid-druid-datasource";
  version = "1.2.0";
  zipHash = "sha256-DPeyV2jZquSQcSE+HzvxArWEefs9bFNPjZwDFp+dIjg=";
  meta = with lib; {
    description = "Connects Grafana to Druid";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
    platforms = platforms.unix;
  };
}
