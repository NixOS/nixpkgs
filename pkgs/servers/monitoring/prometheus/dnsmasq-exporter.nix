{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dnsmasq_exporter-unstable-2018-05-05";

  goPackagePath = "github.com/google/dnsmasq_exporter";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    sha256 = "1kzq4h7z28xadx425nbgxadk62yiz6279d300fyiyi83hwq0ay8c";
    rev = "e1f281b435bbefbb2d17fc57c051ede0ab973c59";
  };

  goDeps = ./dnsmasq-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A dnsmasq exporter for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
