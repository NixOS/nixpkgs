{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dnsmasq_exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    sha256 = "1i7imid981l0a9k8lqyr9igm3qkk92kid4xzadkwry4857k6mgpj";
    rev = "v${version}";
  };

  vendorSha256 = "1dqpa180pbdi2gcmp991d4cry560mx5rm5l9x065s9n9gnd38hvl";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dnsmasq; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A dnsmasq exporter for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ];
  };
}
