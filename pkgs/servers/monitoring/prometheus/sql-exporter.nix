{ lib, buildGoModule, fetchFromGitHub, go, prometheus-sql-exporter, testers }:

buildGoModule rec {
  pname = "sql_exporter";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A3hMSnfxiEgFYueARuldEHT/5ROCIwWjqQj2FdkVYqo=";
  };

  vendorSha256 = null;

  ldflags = let t = "github.com/prometheus/common/version"; in
    [
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=${src.rev}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  passthru.tests.version = testers.testVersion {
    package = prometheus-sql-exporter;
    command = "sql_exporter -version";
  };

  meta = with lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
  };
}
