{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-opensearch-datasource";
  version = "2.14.4";
  zipHash = {
    x86_64-linux = "sha256-xGbPwUuuPqIacTY3PeYqqzncT/UruaLFctAa+TkpXEs=";
    aarch64-linux = "sha256-nuJ2ftJVor/yRnS4vpRgrikjJkRz+MQrWyKiYKHR8+U=";
    x86_64-darwin = "sha256-rvkH43JyjJzfRKcBbfFsA+9t7c+G95w5luzgaCjnaSU=";
    aarch64-darwin = "sha256-vriE4m0oysezQECgl5qjaNSqkvfDgqbmUWhwIuqtYoU=";
  };
  meta = with lib; {
    description = "The Grafana JSON Datasource plugin empowers you to seamlessly integrate JSON data into Grafana.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
