{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-pyroscope-app";
  version = "2.2.0";
  zipHash = "sha256-3Mu2M46Rrlp0gXOyb0GtDSWzc+xShFv+0CLJ3e4e/XY=";
  meta = {
    description = "Integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lpostula ];
    platforms = lib.platforms.unix;
  };
}
