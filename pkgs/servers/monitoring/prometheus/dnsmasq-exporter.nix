{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dnsmasq_exporter-${version}";
  version = "0.1.0";

  goPackagePath = "github.com/google/dnsmasq_exporter";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    sha256 = "0pl4jkp0kssplv32wbg8yk06x9c2hidilpix32hdvk287l3ys201";
    rev = "v${version}";
  };

  goDeps = ./dnsmasq-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A dnsmasq exporter for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
