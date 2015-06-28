{ stdenv, lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-node-exporter-${rev}";
  rev = "0.8.1";
  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    inherit rev;
    sha256 = "15vp88w0b7h6sryy61qk369yjr3p4qvpch1nbxd9rm51bdgsqyys";
  };

  buildInputs = [
    glog
    go-runit
    ntp
    prometheus.client_golang
    prometheus.client_model
    protobuf
  ];

  meta = with lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
