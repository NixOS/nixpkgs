{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mysqld_exporter";
  version = "0.13.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "05gb6p65a0ys356qnanwc40klz1izrib37rz5yzyg2ysvamlvmys";
  };

  vendorSha256 = "19785rfzlx8h0h8vmg0ghd40h3p4y6ikhgf8rd2qfj5f6qxfhrgv";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-s" "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=${rev}"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
  ];

  # skips tests with external dependencies, e.g. on mysqld
  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley globin ];
    platforms = platforms.unix;
  };
}
