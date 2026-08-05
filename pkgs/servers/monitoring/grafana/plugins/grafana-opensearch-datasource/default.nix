{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.34.0";
  zipHash = {
    x86_64-linux = "sha256-/NG+38zeIcoiQTm/QJFwwZSpo0zdovh1a4QntndcphE=";
    aarch64-linux = "sha256-jGRMlbOsOd7fglTMmdOSGxNv4GiV9aiusXz6CnCefaY=";
    aarch64-darwin = "sha256-WzhbYvgkuIzB8coJMinLiEyW3RIFxftM2ZGPG9rGGxU=";
  };
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
