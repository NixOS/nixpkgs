{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "blackbox_exporter";
  version = "0.28.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "sha256-Wt4AVBDptGJ4BlPzdaym5YyXRo0ApBDGEhoSrX7oRf4=";
  };

  vendorHash = "sha256-WhXKBG1eCbXFQZmLwKsxjVV6uAfCMEIqco8Jr+vNdPI=";

  # dns-lookup is performed for the tests
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) blackbox; };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  meta = {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    mainProgram = "blackbox_exporter";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      globin
      fpletz
      Frostman
      ma27
    ];
  };
}
