{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-github-datasource";
  version = "1.9.2";
  zipHash = {
    x86_64-linux = "sha256-gh+vdZ8vkG/0OosqJSoh54Gi3JQGGm7YF0YgQCXr0LY=";
    aarch64-linux = "sha256-OEDT5N/AyL3xocl1nesV9hCcfA/a8XBPBoaOH4UTo+M=";
    x86_64-darwin = "sha256-5WrWvZriXjQIId52Y6THAVg7RfQFl1CT5qhKr/m0vVk=";
    aarch64-darwin = "sha256-sGkuQ91yOGRV3vbvpb4jYg3Orb7XznPPC+Ai7rjogMs=";
  };
  meta = with lib; {
    description = "The GitHub data source lets you visualize GitHub data in Grafana dashboards.";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lukas-mertens ];
    platforms = attrNames zipHash;
  };
}
