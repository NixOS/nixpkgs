{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-Wl84/jNJngIdl/u8JYcHSeq07+qwfRgDH4v4yZVPq3k=";
  };

  vendorHash = "sha256-/9a3lB9V25OppkeLsIr02LZPLAQrQYZ74RJIDHiG6w8=";

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
      ma27
    ];
  };
}
