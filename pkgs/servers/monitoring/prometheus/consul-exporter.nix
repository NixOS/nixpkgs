{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-2X1nJIUwp7kqqz/D3x4bq6vHg1N8zC9AWCn02qsAyAQ=";
  };

  vendorHash = "sha256-z9+WrJDgjQYf4G90sdqY+SOGJa/r5Ie9GFVrihbaGGU=";

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
