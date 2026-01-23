{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-sentry-datasource";
  version = "2.2.1";
  zipHash = "sha256-VJ1RpVWT3d+BrZ9zUoAaNshrE3zBgEkimqUl+innBhg=";
  meta = {
    description = "Integrate Sentry data into Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
    platforms = lib.platforms.unix;
  };
}
