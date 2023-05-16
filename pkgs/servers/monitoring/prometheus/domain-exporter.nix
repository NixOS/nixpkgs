{ lib, buildGoModule, fetchFromGitHub, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
<<<<<<< HEAD
  version = "1.21.1";
=======
  version = "1.17.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qZle54BxKdPuVFNEGmXBNU93yF/MESUnW1a24BRxlZ8=";
  };

  vendorHash = "sha256-UO4fCJD3PldU2wQ9264OLKHP10c0pKPsOc/8gP5ddW4=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak peterhoeg caarlos0 ];
  };
}
