{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.9.4";
  zipHash = {
    x86_64-linux = "sha256-KwhLpAYW3FYTcZWiUiuzoxu/fGdfOl0iX7bumDIrdxg=";
    aarch64-linux = "sha256-lpIfE95eMIapD5i1/7br49YFtaDXPnhoajdb6MiZ5Tc=";
    aarch64-darwin = "sha256-OlnFrn7KuwuIkCfHEhV3UECqMFthkLIL35GoGc1zW/Y=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
