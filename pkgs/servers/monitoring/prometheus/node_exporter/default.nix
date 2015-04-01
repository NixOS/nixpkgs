{ stdenv, lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-node-exporter-0.8.0";
  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "node_exporter";
    rev = "aaf01e52e25883671fd67234b415df7abd0e4eac";
    sha256 = "0j1qvgsc2hcv50l9lyfivkzsyjkjp3w1yyqvd1gzfybk7hi59dya";
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
