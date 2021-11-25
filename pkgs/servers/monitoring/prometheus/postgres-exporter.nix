{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-QU/pPw0gOHF5SAET8S/v7nTPyEvBqkxwwGQ42PbQNvw=";
  };

  vendorSha256 = "sha256-sSJjJR0wlW95I6bgzLKx4aVcqwKMRyzzWC4uz0BKLNY=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
