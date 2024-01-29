{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "systemd_exporter";
  version = "0.6.0";

  vendorHash = "sha256-D5ASUP6XHNeHZqH/ui5GvxWis/NQrRpN/+wkO4fKkA8=";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zLg4cOZUh50OFPp4mKR/FY0JfzVmXmDFcKkhB6DalGc=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) systemd; };

  meta = with lib; {
    description = "Exporter for systemd unit metrics";
    homepage = "https://github.com/prometheus-community/systemd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ chkno ];
  };
}
