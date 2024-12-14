{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-zsSqZGgvhi7K9eKFGkfFP2CAkKBn9ZS4p+qQjrVjuyw=";
  };

  vendorHash = "sha256-FQ9fh6SJ1ebDOfneSJh/EKHGEM5nId518q5HG9YlSYk=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
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
    description = "Prometheus exporter for PostgreSQL";
    mainProgram = "postgres_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fpletz
      globin
      willibutz
      ma27
    ];
  };
}
