{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-csv-datasource";
  version = "0.6.19";
  zipHash = {
    x86_64-linux = "sha256-HCwh8v9UeO7eeESZ78Hj6uvLext/x7bPfACe1u2BqTM=";
    aarch64-linux = "sha256-2Qtwe34fe8KlIye3RuuNLjlWWgXGJvAmwWUnZD8LdWE=";
    x86_64-darwin = "sha256-6sGA06INQbiRCd23ykdtUWAR+oA3YFh57KBT7zWUP44=";
    aarch64-darwin = "sha256-gzQRcPeRqLvl27SB18hTTtcHx/namT2V0NOgX5J1mbs=";
  };
  meta = with lib; {
    description = "The Grafana CSV Datasource plugin is designed to load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
