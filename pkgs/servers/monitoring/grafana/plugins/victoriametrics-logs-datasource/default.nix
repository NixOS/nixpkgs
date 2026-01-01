{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-logs-datasource";
<<<<<<< HEAD
  version = "0.23.2";
  zipHash = "sha256-IINon0NCv2tzmyfQkmHeRhTzfBFT2ZYXDPNTLc8YPBg=";
=======
  version = "0.21.1";
  zipHash = "sha256-mhGxUt+JWX4i/CYcJOAYpCszF4F2ieaosERVoFUg/mU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Grafana datasource for VictoriaLogs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samw
      shawn8901
    ];
    platforms = lib.platforms.unix;
  };
}
