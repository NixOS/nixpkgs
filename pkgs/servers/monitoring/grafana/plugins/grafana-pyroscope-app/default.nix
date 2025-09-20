{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-pyroscope-app";
  version = "1.8.1";
  zipHash = "sha256-dAjvcWUtk518lx4eHalJJxUVSna9+A/Ow9mmsrBX+nQ=";
  meta = {
    description = "Integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
  };
}
