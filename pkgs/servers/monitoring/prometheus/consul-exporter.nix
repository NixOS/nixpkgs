{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "consul_exporter";
  version = "0.7.1";

  goPackagePath = "github.com/prometheus/consul_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "v${version}";
    sha256 = "16ibafcbpiplsh1awcvblzzf2cbr4baf8wiwpdpibgmcwwf9m5ya";
  };

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
    platforms = platforms.unix;
  };
}
