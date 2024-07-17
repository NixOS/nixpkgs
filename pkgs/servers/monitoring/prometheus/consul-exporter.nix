{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-qLc0CG+N3OF1V6rJQCWDxIrsU0lHoskMNUbwsx8pcPs=";
  };

  vendorHash = "sha256-G7Gf3igUnDID9hTuvIHd7syii2+3dPAlewsW8yKNJvs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    mainProgram = "consul_exporter";
    homepage = "https://github.com/prometheus/consul_exporter";
    changelog = "https://github.com/prometheus/consul_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
  };
}
