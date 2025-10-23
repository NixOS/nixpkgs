{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-googlesheets-datasource";
  version = "1.2.14";
  zipHash = {
    x86_64-linux = "sha256-N4JZ/aWpvezR9daJKU559GXd+FNGmDA4P9CrlC4RFmQ=";
    aarch64-linux = "sha256-HZhyg6NhptFib/3JJ8AnSywF+eaZOwiCij3TlMB0YG8=";
    x86_64-darwin = "sha256-EwE6w67ARVp/2GE9pSqaD5TuBnsgwsDLZCrEXPfRfUE=";
    aarch64-darwin = "sha256-3UGd/t1k6aZsKsQCplLV9klmjQAga19VaopHx330xUs=";
  };
  meta = with lib; {
    description = "Integrate JSON data into Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
