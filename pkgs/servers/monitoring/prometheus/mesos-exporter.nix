{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mesos_exporter-${version}";
  version = "0.1.0";
  rev = version;

  goPackagePath = "github.com/prometheus/mesos_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mesos_exporter";
    sha256 = "059az73j717gd960g4jigrxnvqrjh9jw1c324xpwaafa0bf10llm";
  };

  goDeps = ./mesos-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "Export Mesos metrics to Prometheus";
    homepage = https://github.com/prometheus/mesos_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
