{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.10.2";
  zipHash = "sha256-wRgzdPKSA24O4kSDhaO/09uOG6lIoJGWUGOgX1vdjlU=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = platforms.unix;
  };
}
