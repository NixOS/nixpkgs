{ lib, stdenv, buildGoModule, fetchFromGitHub, nixosTests
  # darwin
  , CoreFoundation, IOKit
}:

buildGoModule rec {
  pname = "node_exporter";
<<<<<<< HEAD
  version = "1.6.1";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
<<<<<<< HEAD
    sha256 = "sha256-BCZLMSJP/63N+pZsK8er87Zem7IFGdkyruDs6UVDZSM=";
  };

  vendorHash = "sha256-hn2cMKhLl5qsm4sZErs6PXTs8yajowxw9a9vtHe5cAk=";
=======
    sha256 = "sha256-jzgf7XVqtqHf5Uqkcr/0epC0R0fw7l7acr+F8jZ6M68=";
  };

  vendorSha256 = "sha256-k4Wolrp/mebwA6ZLftCNVFOdHoXHcJZI9JWrhBxX5Pk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation IOKit ];

  excludedPackages = [ "docs/node-mixin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) node; };

  meta = with lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = "https://github.com/prometheus/node_exporter";
<<<<<<< HEAD
    changelog = "https://github.com/prometheus/node_exporter/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
  };
}
