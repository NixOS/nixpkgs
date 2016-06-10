{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "prometheus_cli-${version}";
  version = "0.3.0";
  rev = version;

  goPackagePath = "github.com/prometheus/prometheus_cli";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prometheus_cli";
    sha256 = "1qxqrcbd0d4mrjrgqz882jh7069nn5gz1b84rq7d7z1f1dqhczxn";
  };

  goDeps = ./cli_deps.json;

  meta = with stdenv.lib; {
    description = "Command line tool for querying the Prometheus HTTP API";
    homepage = https://github.com/prometheus/prometheus_cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
