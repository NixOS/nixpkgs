{ stdenv, lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-cli-${rev}";
  rev = "0.3.0";
  goPackagePath = "github.com/prometheus/prometheus_cli";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus_cli";
    inherit rev;
    sha256 = "1qxqrcbd0d4mrjrgqz882jh7069nn5gz1b84rq7d7z1f1dqhczxn";
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
