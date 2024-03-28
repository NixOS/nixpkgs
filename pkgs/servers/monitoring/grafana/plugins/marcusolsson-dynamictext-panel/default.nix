{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "marcusolsson-dynamictext-panel";
  version = "4.3.0";
  zipHash = "sha256-GsgN+m32517P3ZUHPskyjtvFlaI3CO7fyQ8T3URThqc=";
  meta = with lib; {
    description = "Dynamic Text Panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
