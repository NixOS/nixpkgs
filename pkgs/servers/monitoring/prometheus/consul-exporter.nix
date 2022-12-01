{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "v${version}";
    sha256 = "sha256-5odAKMWK2tDZ3a+bIVIdPgzxrW64hF8nNqItGO7sODI=";
  };

  vendorSha256 = "sha256-vbaiHeQRo9hsHa/10f4202xLe9mduELRJMCDFuyKlW0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
    platforms = platforms.unix;
  };
}
