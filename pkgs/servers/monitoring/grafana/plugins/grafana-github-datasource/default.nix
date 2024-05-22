{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-github-datasource";
  version = "1.5.4";
  zipHash = {
    x86_64-linux = "sha256-GE3Aff4kSB/AJCID10mIKdRj/tMUxgkwe6/7e9tNg7E=";
    aarch64-linux = "sha256-eelcMKyBgzQfpzvYOR8sBgnNGr7esLD7PxVczFFWr68=";
    x86_64-darwin = "sha256-LWSmbwExn/+dr3qjJwBfflZsiqHluW1gWDfgYacvGVE=";
    aarch64-darwin = "sha256-03ufNyCuLWhCKtiXoFsB1Y/b9bPN9jw7JhJFTGGaaRA=";
  };
  meta = with lib; {
    description = "The GitHub datasource allows GitHub API data to be visually represented in Grafana dashboards.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
