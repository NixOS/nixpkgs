{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-csv-datasource";
  version = "0.6.14";
  zipHash = {
    x86_64-linux = "sha256-9KuUg7oUrXWQToRA7Ra+PIof1BJdtNS5+qBN4Gbuo5o=";
    aarch64-linux = "sha256-/4amtu5XVDN1/eMuzhm0X3bumJNQ9ucfve84zZJsbUg=";
    x86_64-darwin = "sha256-3Fi55ye+sFHnzON0aI8pDnrPlqM9x7U5D2WClZnUJxQ=";
    aarch64-darwin = "sha256-ik16a6oksUbav9on9KYRejGEek0uWpE5iV40hhJAVfA=";
  };
  meta = with lib; {
    description = "The Grafana CSV Datasource plugin is designed to load CSV data into Grafana, expanding your capabilities to visualize and analyze data stored in CSV (Comma-Separated Values) format.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
