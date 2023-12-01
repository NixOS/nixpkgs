{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mysqld_exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    rev = "v${version}";
    sha256 = "sha256-LW9vH//TjnKbZGMF3owDSUx/Mu0TUuWxMtmdeKM/q7k=";
  };

  vendorHash = "sha256-8zoiYSW8/z1Ch5W1WJHbWAPKFUOhUT8YcjrvyhwI+8w=";

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-s" "-w"
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=${src.rev}"
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
  };
}
