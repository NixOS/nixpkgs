{
  grafanaPlugin,
  fetchurl,
  lib,
}:
let
  zipHash = "sha256-1+5xil0XmcLCDKpObuxpnoMnQZaT1I62zL6xatlyKc4=";
in
(grafanaPlugin {
  pname = "grafana-logs-drilldown";
  version = "1.0.10";
  inherit zipHash;
  meta = with lib; {
    description = "Loki log exploration app.";
    license = licenses.agpl3Only;
    maintainers = [ lib.maintainers.jonboh ];
    platforms = platforms.unix;
  };
}).overrideAttrs
  (
    prev: final:
    let
      pluginName = "grafana-lokiexplore-app";
    in
    {
      src = fetchurl {
        name = "${pluginName}-${prev.version}.zip";
        hash = zipHash;
        url = "https://grafana.com/api/plugins/${pluginName}/versions/${prev.version}/download";
      };
    }
  )
