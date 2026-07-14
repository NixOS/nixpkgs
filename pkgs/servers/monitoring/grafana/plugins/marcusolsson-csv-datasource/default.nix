{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "marcusolsson-csv-datasource";
  version = "1.0.0";
  zipHash = {
    x86_64-linux = "sha256-lG8kpRSPXYWPag4fBAPi9QU73hAawJ0kpFsmKVdZpyc=";
    aarch64-linux = "sha256-k8ba5JY1ezQSzey1BORFuQ1K2oVMy8mfnZn6m6BhaOo=";
    x86_64-darwin = "sha256-Mf0Ck7m9H3nI83XJy7P5ToruADRNdPqoUTvwjl6vptw=";
    aarch64-darwin = "sha256-9XNbx4KdBVOYKmHA+whnTsG7ykVNb3jMHlsRswDAoGE=";
  };
  meta = {
    description = "Load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
