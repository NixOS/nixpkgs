{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-datasource";
  version = "2.2.0";
  zipHash = "sha256-a4at8o185XSOyNxZZKfb0/j1CVoKQ9JZx0ofoPUBqKs=";
<<<<<<< HEAD
  meta = {
    description = "Redis Data Source for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Redis Data Source for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
