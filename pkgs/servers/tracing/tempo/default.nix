{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "tempo";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-23wjD8HTSEGonIMAWCoKORMLIISASxlN4FeY+Bmt/+I=";
  };

  patches = [
    # Backport patch for Go 1.21 compatibility
    # FIXME: remove after 2.3.0
    (fetchpatch {
      url = "https://github.com/grafana/tempo/commit/0d37e8f0edd8a96876b0a5f5ab97ef79ff04608f.patch";
      hash = "sha256-YC59g5pdcrwJeQ4raS0Oq+fZvRBKFj4johZtGTAYpEs=";
    })
  ];

  vendorHash = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-serverless"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${version}"
  ];

  # tests use docker
  doCheck = false;

  meta = with lib; {
    description = "A high volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = with maintainers; [ willibutz ];
  };
}
