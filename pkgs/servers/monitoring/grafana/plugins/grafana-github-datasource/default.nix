{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.9.0";
  zipHash = {
    x86_64-linux = "sha256-pGkg4GQwg8oPgUOYThfa/rnf+/jTAURwuwthLYagWvw=";
    aarch64-linux = "sha256-/8rEZiUK4OBDktDtwZFl1dlt7Pk1KksjXJTjKZVNl+Y=";
    aarch64-darwin = "sha256-Yq4qXFMgEuPwq5+W/gcgTQSwww1QawhzuvPicCdgtEs=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
