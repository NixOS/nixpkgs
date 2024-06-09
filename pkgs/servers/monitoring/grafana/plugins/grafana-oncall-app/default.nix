{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.5.1";
  zipHash = "sha256-3mC4TJ9ACM9e3e6UKI5vaDwXuW6RjbsOQFJU5v0wjk8=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = platforms.unix;
  };
}
