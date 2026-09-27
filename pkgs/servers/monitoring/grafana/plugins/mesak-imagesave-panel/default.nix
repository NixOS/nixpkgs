{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "mesak-imagesave-panel";
  version = "1.0.4";
  zipHash = "sha256-WwGCcMhPhE8q2E/0uXYNMpd0HitPvVOCbazhpX/1q2U=";
  meta = {
    description = "Plugin for Grafana that allows you to save image to grafana and display it in dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
}
