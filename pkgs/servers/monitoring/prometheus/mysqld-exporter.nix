{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mysqld_exporter";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    rev = "v${version}";
    sha256 = "sha256-uHr9hVjnQx1DIr7ByaqgmR4YOvCYo49+b+Ikh+Vlh+o=";
  };

  vendorHash = "sha256-fM3CqyOEKYJOFkEwBE7/yIQEKUUIbBIbmHQp12/psas=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=${src.rev}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  # skips tests with external dependencies, e.g. on mysqld
  checkFlags = [
    "-short"
  ];

  meta = with lib; {
    description = "Prometheus exporter for MySQL server metrics";
    mainProgram = "mysqld_exporter";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      globin
    ];
  };
}
