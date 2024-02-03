{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "systemd_exporter";
  version = "0.5.0";

  vendorHash = "sha256-XkwBhj2M1poirPkWzS71NbRTshc8dTKwaHoDfFxpykU=";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q6rnD8JCtB1zTkUfZt6f2Uyo91uFi3HYI7WFlZdzpBM=";
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
