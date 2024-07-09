{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mysqld_exporter";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    rev = "v${version}";
    sha256 = "sha256-P7EoWa0BWuAr3sjtrUxzofwlklhRLpzwpGVe31hFo7Q=";
  };

  vendorHash = "sha256-GEL9sMwwdGqpklm4yKNqzSOM6I/JzZjg3+ZB2ix2M8w=";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-s" "-w"
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
    maintainers = with maintainers; [ benley globin ];
  };
}
