{ lib, stdenv, buildGoModule, fetchFromGitHub, nixosTests
  # darwin
  , CoreFoundation, IOKit
}:

buildGoModule rec {
  pname = "node_exporter";
  version = "1.4.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "sha256-KO33Cyrc4Oh6vvTMazo5iuekpyxNsi18gIb66Z8B9i4=";
  };

  vendorSha256 = "sha256-eJbb56U6VStwfi6iSemWrriDYNaPiDegW3KJr8rH1NU=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
  };
}
