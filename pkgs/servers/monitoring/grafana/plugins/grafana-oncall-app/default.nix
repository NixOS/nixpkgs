{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-oncall-app";
  version = "1.3.102";
  zipHash = "sha256-a4SyCb3rReHW2JSl2cHIXmj3QhSq50cFu2+J6QaAuRI=";
  meta = with lib; {
    description = "Developer-Friendly Alert Management with Brilliant Slack Integration";
    license = licenses.agpl3;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
