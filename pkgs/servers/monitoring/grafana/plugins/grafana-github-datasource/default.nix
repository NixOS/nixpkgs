{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.9.3";
  zipHash = {
    x86_64-linux = "sha256-jnf2Z5r7s6TVqJlpLaZfYJBb7G21ChrYD3jJWiD/ahI=";
    aarch64-linux = "sha256-M6d4LWL1sVAMFg6Q3zAb+YdTaBkcBPO3tp4QnD3SlcQ=";
    aarch64-darwin = "sha256-X0jpE+R3HqZOkpZ5BMhuITc6UWv4rPepeMbxhiFO/2o=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
