{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  version = "1.0.4";
  zipHash = {
    x86_64-linux = "sha256-+KWTg9vwiQQnUiww/+NhB2/4kphRFsiQTc2422ixG74=";
    aarch64-linux = "sha256-Xb7/BALWemvaY+wk8qAfE1RuXwFsKBl8Kj/0bOSPaWI=";
    aarch64-darwin = "sha256-TNSeqT4Vu7CUZyKiK/Kc0THQNHozLQihn29alDBfcx8=";
  };
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
