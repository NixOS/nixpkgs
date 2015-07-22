{ stdenv, lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-mesos-exporter-${rev}";
  rev = "0.1.0";
  goPackagePath = "github.com/prometheus/mesos_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mesos_exporter";
    sha256 = "059az73j717gd960g4jigrxnvqrjh9jw1c324xpwaafa0bf10llm";
  };

  buildInputs = [
    goPackages.mesos-stats
    goPackages.prometheus.client_golang
    goPackages.glog
  ];

  meta = with lib; {
    description = "Export Mesos metrics to Prometheus";
    homepage = https://github.com/prometheus/mesos_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
