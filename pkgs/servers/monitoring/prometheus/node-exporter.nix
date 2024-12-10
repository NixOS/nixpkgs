{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  # darwin
  CoreFoundation,
  IOKit,
}:

buildGoModule rec {
  pname = "node_exporter";
  version = "1.8.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    hash = "sha256-dg4JSJx5xXEOLLb5xEgrNeDmh/En9G6qKA9G+3v9PH0=";
  };

  vendorHash = "sha256-sly8AJk+jNZG8ijTBF1Pd5AOOUJJxIG8jHwBUdlt8fM=";

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

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
    mainProgram = "node_exporter";
    homepage = "https://github.com/prometheus/node_exporter";
    changelog = "https://github.com/prometheus/node_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
}
