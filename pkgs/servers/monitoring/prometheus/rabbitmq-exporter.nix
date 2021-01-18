{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rabbitmq_exporter";
  version = "1.0.0-RC7.1";

  goPackagePath = "github.com/kbudde/rabbitmq_exporter";

  src = fetchFromGitHub {
    owner = "kbudde";
    repo = "rabbitmq_exporter";
    rev = "v${version}";
    sha256 = "5Agg99yHBMgpWGD6Nk+WvAorRc7j2PGD+3z7nO3N/5s=";
  };

  goDeps = ./rabbitmq-exporter_deps.nix;

  meta = with lib; {
    description = "Prometheus exporter for RabbitMQ";
    homepage = "https://github.com/kbudde/rabbitmq_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
