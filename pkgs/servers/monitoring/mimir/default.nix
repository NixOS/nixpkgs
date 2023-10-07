{ lib, buildGoModule, fetchFromGitHub, nixosTests, nix-update-script }:
buildGoModule rec {
  pname = "mimir";
  version = "2.10.0";

  src = fetchFromGitHub {
    rev = "${pname}-${version}";
    owner = "grafana";
    repo = pname;
    hash = "sha256-4UBbtJRQ6F3Dm+G4OWZeWtD4MJWtq91yiSZNW7EhEto=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/mimir"
    "cmd/mimirtool"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "mimir-([0-9.]+)" ];
    };
    tests = {
      inherit (nixosTests) mimir;
    };
  };

  ldflags =
    let t = "github.com/grafana/mimir/pkg/util/version";
    in [
      ''-extldflags "-static"''
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
    ];

  meta = with lib; {
    description =
      "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada bryanhonof ];
  };
}
