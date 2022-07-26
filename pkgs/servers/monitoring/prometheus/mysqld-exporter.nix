{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mysqld_exporter";
  version = "0.14.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "sha256-SMcpQNygv/jVLNuQP8V6BH/CmSt5Y4dzYPsboTH2dos=";
  };

  vendorSha256 = "sha256-M6u+ZBEUqCd6cKVHPvHqRiXLbuWz66GK+ybIQm+5tQE=";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-s" "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=${rev}"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
  ];

  # skips tests with external dependencies, e.g. on mysqld
  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley globin ];
    platforms = platforms.unix;
  };
}
