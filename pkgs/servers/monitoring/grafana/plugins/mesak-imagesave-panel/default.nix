{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "mesak-imagesave-panel";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Plugin for Grafana that allows you to save image to grafana and display it in dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
