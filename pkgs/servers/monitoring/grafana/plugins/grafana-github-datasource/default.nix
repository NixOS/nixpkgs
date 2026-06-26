{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "2.8.0";
  zipHash = {
    x86_64-linux = "sha256-hKElyWX4fcQtF3eyYVRuaJjvNWY9CV2bNoNkFLeJQLc=";
    aarch64-linux = "sha256-+ygxJc+ovlqjcs68QD71JQepINTeauA41sKrJa6h8gc=";
    x86_64-darwin = "sha256-ZrvBxCi6gyRFly0NtTPWUWzTbH3rp92Vy0C4n1hO/pA=";
    aarch64-darwin = "sha256-s4q+k1gbOBCeMDpkTpui0egOxzoBjbKoX63pwVqmY6A=";
  };
  meta = {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
