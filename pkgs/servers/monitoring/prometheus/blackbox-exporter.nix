{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "blackbox_exporter";
  version = "0.20.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "sha256-Y3HdFIChkQVooxy2I2Gbqw3WLHsI4Zm+osHTzFluRZA=";
  };

  vendorSha256 = "sha256-KFLR0In4txQQp5dt8P0yAFtf82b4SBq2xMnlz+vMuuU=";

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

  meta = with lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz Frostman ma27 ];
    platforms = platforms.unix;
  };
}
