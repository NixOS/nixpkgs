{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-opensearch-datasource";
  version = "2.34.3";
  zipHash = {
    x86_64-linux = "sha256-P5NlM7TZWLVbKbYFy9TzqwRiKQZkXsOxmUJbWx+6TAI=";
    aarch64-linux = "sha256-MLpS4NHu0F7a1eQOTMYuZi3N/ESn+jXKMhspl2DoqhE=";
    aarch64-darwin = "sha256-PIqemTwdml2c9y6RKfOrYB6IIqwgmy0zB33CKizCwqY=";
  };
  meta = {
    description = "Empowers you to seamlessly integrate JSON data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
