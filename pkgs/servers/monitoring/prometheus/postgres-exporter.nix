{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-fxVU2z1RGgI8AoKiJb+3LIEa1KDhPptmdP21/ESzmgw=";
  };

  vendorHash = "sha256-/AL9Qkcrp5Kvj2epJMuNrtwqBbyCy4P6oVGUfODXS/Q=";

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
    description = "Prometheus exporter for PostgreSQL";
    mainProgram = "postgres_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
