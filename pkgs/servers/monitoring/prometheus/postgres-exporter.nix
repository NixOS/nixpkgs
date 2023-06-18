{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-/IIMtLjOKmkqsNVgqrMo8D8r/NDmg4NRWCEMJTNgLbk=";
  };

  vendorSha256 = "sha256-sMWprCRUvF6voLM3GjTq9tId1GoCPac/RE6hXL+LBEE=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
