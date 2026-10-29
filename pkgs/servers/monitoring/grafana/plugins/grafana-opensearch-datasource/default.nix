{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.34.6";
  zipHash = {
    x86_64-linux = "sha256-7F8C0wADZqLwkwgcaRI9WkcC0KKE8L1Dmotw2nMa5qo=";
    aarch64-linux = "sha256-VeaulhIcp1f0BrOixhxVeI0awRYSTIhsHfgq7wgnK0M=";
    aarch64-darwin = "sha256-Xif362JJ6i6VAaK7KP3qzIYvFUPFTNj02NKI3CzrnWY=";
  };
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
