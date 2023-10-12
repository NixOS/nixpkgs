{ lib, buildGoModule, fetchFromGitHub, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-qZle54BxKdPuVFNEGmXBNU93yF/MESUnW1a24BRxlZ8=";
  };

  vendorHash = "sha256-UO4fCJD3PldU2wQ9264OLKHP10c0pKPsOc/8gP5ddW4=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak peterhoeg caarlos0 ];
  };
}
