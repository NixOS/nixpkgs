{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.9.2";
  zipHash = {
    x86_64-linux = "sha256-fDqIX16xnXUUi48nIl0RkgHLix/7bUs1WZaBecub/Io=";
    aarch64-linux = "sha256-y16lRpPG2ft3gs9S47TdgQInoEdttx6pWeceNpROjKI=";
    aarch64-darwin = "sha256-JWnAYwVSJUEqcBbjCKstkEY5HNlAesZRnT89ji2rias=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
