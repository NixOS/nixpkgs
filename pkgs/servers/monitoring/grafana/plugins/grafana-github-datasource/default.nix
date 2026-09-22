{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.9.1";
  zipHash = {
    x86_64-linux = "sha256-nesDTVcurnKkMoWTfa5aEbTk7BQ3AW5iAC1tomR0xiE=";
    aarch64-linux = "sha256-bAuSHzwQL+633x/bCew3tvJH9BCKyjs3oi7GXmOpgtE=";
    aarch64-darwin = "sha256-U8RT4ivKjvxMpAj6TmCrF+VRzT3PiDF/doAwi99S+eo=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
