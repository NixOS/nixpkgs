{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "2.5.0";
  zipHash = {
    x86_64-linux = "sha256-X4kPz/9o63giMRyVztix0OPO9Ip6sn/bH1Y2V1u/6qw=";
    aarch64-linux = "sha256-o2OQsGX8pcKUxnJw1+6rnrXTkDYXCuVhnfFYzmGBVYU=";
    x86_64-darwin = "sha256-n+BTCyzQo6FxeUX9VE8Kf9DNTgEYq+BaAUwo9vh7XSo=";
    aarch64-darwin = "sha256-UKYtxzXeI547fxmTkfHxR7vEHwkPIGUd6AB4ZBa9DSY=";
  };
  meta = {
    description = "Integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
