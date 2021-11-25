{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "blackbox_exporter";
  version = "0.19.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "1lrabbp6nsd9h3hs3y5a37yl4g8zzkv0m3vhz2vrir3wmfn07n4g";
  };

  vendorSha256 = "1wi9dmbxb6i1qglnp1v0lkqpp7l29lrbsg4lvx052nkcwkgq8g1y";

  # dns-lookup is performed for the tests
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) blackbox; };

  meta = with lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz Frostman ];
    platforms = platforms.unix;
  };
}
