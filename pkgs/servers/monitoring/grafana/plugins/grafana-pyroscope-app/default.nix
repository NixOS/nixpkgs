{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-pyroscope-app";
  version = "1.16.0";
  zipHash = "sha256-wsDzFq5i4Nsud/tAuX5Lg7vxRR7ndDhAcD/zhrAEct8=";
  meta = {
    description = "Integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
