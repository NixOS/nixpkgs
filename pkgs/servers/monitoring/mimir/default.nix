{ lib, buildGoModule, fetchFromGitHub, nixosTests, nix-update-script }:
buildGoModule rec {
  pname = "mimir";
  version = "2.9.0";

  src = fetchFromGitHub {
    rev = "${pname}-${version}";
    owner = "grafana";
    repo = pname;
    sha256 = "sha256-6URhofT5zJZX2eFx7fNPrFOWF7Po3ChlmVHGTpvG24c=";
  };

  vendorSha256 = null;

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

  ldflags = let t = "github.com/grafana/mimir/pkg/util/version";
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
