{ stdenv, lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-node-exporter-${rev}";
  rev = "0.10.0";
  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    inherit rev;
    sha256 = "0dmczav52v9vi0kxl8gd2s7x7c94g0vzazhyvlq1h3729is2nf0p";
  };

  buildInputs = [
    go-runit
    ntp
    prometheus.client_golang
    prometheus.client_model
    prometheus.log
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
