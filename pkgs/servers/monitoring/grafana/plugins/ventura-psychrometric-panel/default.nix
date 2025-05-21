{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "ventura-psychrometric-panel";
  version = "5.0.0";
  zipHash = "sha256-g14Xosk48dslNROidRDRJGzrDSkeB3cr1PxNrsLMEAA=";
  meta = with lib; {
    description = "Grafana plugin to display air conditions on a psychrometric chart.";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
