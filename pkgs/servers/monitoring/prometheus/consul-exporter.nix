{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "v${version}";
    sha256 = "sha256-Y3H4lFRoOLs8BBWUqfQOl9ny7HoRGqKIiq/ONcnzMW0=";
  };

  vendorSha256 = "sha256-V3IWhVm47Uwgk3Mcu4JcYYGAdCrHDhkXYXCTXQr1BDE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
    platforms = platforms.unix;
  };
}
