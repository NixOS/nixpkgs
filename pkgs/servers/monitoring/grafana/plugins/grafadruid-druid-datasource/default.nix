{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafadruid-druid-datasource";
  version = "1.7.0";
  zipHash = "sha256-aVAIk5x+zKdq5SYjsl5LekZ96LW7g/ykaq/lPUNUi7k=";
<<<<<<< HEAD
  meta = {
    description = "Connects Grafana to Druid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nukaduka ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Connects Grafana to Druid";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
