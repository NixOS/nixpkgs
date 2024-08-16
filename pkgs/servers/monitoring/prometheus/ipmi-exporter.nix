{ lib, buildGoModule, fetchFromGitHub, nixosTests, makeWrapper, freeipmi }:

buildGoModule rec {
  pname = "ipmi_exporter";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "ipmi_exporter";
    rev = "v${version}";
    hash = "sha256-ZF5mBjq+IhSQrQ1dUfHlfyUMK2dkpZ5gu9djPkUYvRQ=";
  };

  vendorHash = "sha256-q5MFAvFCrr24b1VO0Z03C08CGd+0pUerXZEKiu4r7cE=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ipmi_exporter --prefix PATH : ${lib.makeBinPath [ freeipmi ]}
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) ipmi; };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=0000000"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  meta = with lib; {
    description = "IPMI exporter for Prometheus";
    mainProgram = "ipmi_exporter";
    homepage = "https://github.com/prometheus-community/ipmi_exporter";
    changelog = "https://github.com/prometheus-community/ipmi_exporter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ snaar ];
  };
}
