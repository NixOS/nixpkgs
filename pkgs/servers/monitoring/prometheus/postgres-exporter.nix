{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-K0B6EsRCWznYf4xS+9T4HafOSUPHCNsu2ZSIVXneGyk=";
  };

  vendorHash = "sha256-0MQS42/4iImtq3yBGVCe0BwV0HiJCo7LVEAbsKltE4g=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [ "-s" "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
