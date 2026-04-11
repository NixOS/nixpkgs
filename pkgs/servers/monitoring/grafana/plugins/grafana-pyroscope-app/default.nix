{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-pyroscope-app";
  version = "2.0.1";
  zipHash = "sha256-ws/gYJnq2BQHeaPezGFsEgmvbURRo1kCI8yRO5X6588=";
  meta = {
    description = "Integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
