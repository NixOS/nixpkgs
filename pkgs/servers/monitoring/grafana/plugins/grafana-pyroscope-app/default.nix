{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-pyroscope-app";
  version = "1.12.0";
  zipHash = "sha256-Zxp/ebNEwcq/JRhSbtWsFWVY5mIGEexVnH/jtEnKXec=";
  meta = with lib; {
    description = "Integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
