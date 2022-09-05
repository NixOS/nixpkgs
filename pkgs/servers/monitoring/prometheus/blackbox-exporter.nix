{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "blackbox_exporter";
  version = "0.22.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "sha256-TelyZTzh/+fHe42H3AarZzuU8zY1EflHVo9c4WymMVc=";
  };

  vendorSha256 = "sha256-pzEEi9O/Sgsv1dFm7wQt6PaP/beV5PMrXEZC9N/6lUc=";

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
