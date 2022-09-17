{ lib, buildGoModule, fetchFromGitHub, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-18r+jUdVcv7hA9KdWkgvu2tNUIGf9f1uj2cwwMDnAs8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/caarlos0/domain_exporter/commit/32815b0956056c5c14313d0b860d1e9db754e545.patch";
      hash = "sha256-iEYnJ4BU+MWQd0BgKmRb8RNj/lH2V/Z9uwFS2muR4Go=";
      name = "sg_domains.patch";
    })
  ];

  vendorSha256 = "sha256-LHs2DSLNe+E3NUXZS7TV5M53ueUbCjjNM87UPRTaCpo=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak peterhoeg ];
  };
}
