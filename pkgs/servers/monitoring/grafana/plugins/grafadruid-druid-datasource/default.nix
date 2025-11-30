{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafadruid-druid-datasource";
  version = "1.7.0";
  zipHash = "sha256-aVAIk5x+zKdq5SYjsl5LekZ96LW7g/ykaq/lPUNUi7k=";
  meta = with lib; {
    description = "Connects Grafana to Druid";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
    platforms = platforms.unix;
  };
}
