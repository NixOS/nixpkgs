{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-explorer-app";
  version = "2.1.1";
  zipHash = "sha256-t5L9XURNcswDbZWSmehs/JYU7NoEwhX1If7ghbi509g=";
<<<<<<< HEAD
  meta = {
    description = "Redis Explorer plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Redis Explorer plugin for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
