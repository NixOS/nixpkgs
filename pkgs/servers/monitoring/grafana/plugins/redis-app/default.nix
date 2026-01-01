{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "redis-app";
  version = "2.2.1";
  zipHash = "sha256-1ZzJaGhlM6CaTecj69aqJ9fqN7wYSsiDCMTRVkZJUb0=";
<<<<<<< HEAD
  meta = {
    description = "Redis Application plugin for Grafana";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Redis Application plugin for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
