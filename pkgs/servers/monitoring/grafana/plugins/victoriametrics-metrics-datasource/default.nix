{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "victoriametrics-metrics-datasource";
<<<<<<< HEAD
  version = "0.19.7";
  zipHash = "sha256-0XqZoL01/LwcMKFYEcFl88ekCrp94676bvVYj2aBltk=";
=======
  version = "0.19.5";
  zipHash = "sha256-wKLtfCI/onYPFrtP1EUrCbZ+OCHicshRZkZtltH6LzI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "VictoriaMetrics metrics datasource for Grafana";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.shawn8901 ];
    platforms = lib.platforms.unix;
  };
}
