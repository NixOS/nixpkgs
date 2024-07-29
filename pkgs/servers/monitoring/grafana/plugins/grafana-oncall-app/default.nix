{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  versionPrefix = "v";
  version = "1.8.5";
  zipHash = "sha256-HuZYHPTWm0EPKQbmapALK2j+PzM+J7gcWM9w8vU2yI0=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = platforms.unix;
  };
}
