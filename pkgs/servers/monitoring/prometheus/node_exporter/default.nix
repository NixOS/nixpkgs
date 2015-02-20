{ stdenv, lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-node-exporter-0.7.1";
  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    rev = "0c8bfba04df87b90e69a79b2d25a5f627ebde1bb";
    sha256 = "12aj65hl9wql24rlpadd6mibf7sp8593xr1vljgyd5xdf7wjkxn9";
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
