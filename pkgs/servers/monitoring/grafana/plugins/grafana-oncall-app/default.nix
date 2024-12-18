{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  versionPrefix = "v";
  version = "1.7.1";
  zipHash = "sha256-G3QZq26fzv6sJ5j7QKdPPXhEj95iounZO+Ak8cXZDLc=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    maintainers = lib.teams.fslabs.members;
    platforms = platforms.unix;
  };
}
