{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "systemd_exporter";
  version = "0.7.0";

  vendorHash = "sha256-4hsQ1417jLNOAqGkfCkzrmEtYR4YLLW2j0CiJtPg6GI=";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wWXtAyQ48fsh/9BBo2tHXf4QS3Pbsmj6rha28TdBRWI=";
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

  meta = {
    description = "Exporter for systemd unit metrics";
    mainProgram = "systemd_exporter";
    homepage = "https://github.com/prometheus-community/systemd_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
