{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-Y3H4lFRoOLs8BBWUqfQOl9ny7HoRGqKIiq/ONcnzMW0=";
  };

  vendorHash = "sha256-V3IWhVm47Uwgk3Mcu4JcYYGAdCrHDhkXYXCTXQr1BDE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    changelog = "https://github.com/prometheus/consul_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
    platforms = platforms.unix;
  };
}
