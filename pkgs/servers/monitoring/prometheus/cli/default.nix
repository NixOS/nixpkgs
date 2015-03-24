{ stdenv, lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-cli-0.2.0";
  goPackagePath = "github.com/prometheus/prometheus_cli";
  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus_cli";
    rev = "b36c21d2301cf686bff81953573a29a6d5a0a883";
    sha256 = "190dlc6fyrfgxab4xj3gaz4jwx33jhzg57d8h36xjx56gbvp7iyk";
  };

  buildInputs = [
    goPackages.prometheus.client_model
    goPackages.prometheus.client_golang
  ];

  meta = with lib; {
    description = "Command line tool for querying the Prometheus HTTP API";
    homepage = https://github.com/prometheus/prometheus_cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
