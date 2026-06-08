{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafadruid-druid-datasource";
  version = "1.8.0";
  zipHash = "sha256-iCd6OejO+AQtN3tzEJUDZUGa4Fg1X9k4DzUXN9U0Udc=";
  meta = {
    description = "Connects Grafana to Druid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nukaduka ];
    platforms = lib.platforms.unix;
  };
}
