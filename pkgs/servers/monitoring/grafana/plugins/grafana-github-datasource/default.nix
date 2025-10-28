{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-github-datasource";
  version = "1.9.2";
  zipHash = {
    x86_64-linux = "sha256-gh+vdZ8vkG/0OosqJSoh54Gi3JQGGm7YF0YgQCXr0LY=";
    aarch64-linux = "sha256-OEDT5N/AyL3xocl1nesV9hCcfA/a8XBPBoaOH4UTo+M=";
    x86_64-darwin = "sha256-5WrWvZriXjQIId52Y6THAVg7RfQFl1CT5qhKr/m0vVk=";
    aarch64-darwin = "sha256-4IowlmyDGjxHBHvBD/eqZvouuOEvlad0nW8L0n8hf+g";
  };
  meta = with lib; {
    description = "Allows GitHub API data to be visually represented in Grafana dashboards";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
