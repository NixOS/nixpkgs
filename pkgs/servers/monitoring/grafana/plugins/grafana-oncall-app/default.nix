{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-oncall-app";
  version = "1.16.4";
  zipHash = "sha256-sz8jdUBEUpvfvYo0dZU1KVW/65MI5rcheTCia2m4cjU=";
  meta = with lib; {
    description = "Developer-friendly incident response for Grafana";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
  };
}
