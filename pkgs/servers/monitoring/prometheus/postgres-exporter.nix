{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "postgres_exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "sha256-Kv+sjqhlmH36L4YvDuGYODR/eTHA2TKQ6IUCXAiItyo=";
  };

  vendorSha256 = "sha256-yMcoUl9NsiiZQyEHlLu79DzIyl6BbhLZ/xNFavaGrEs=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postgres; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ma27 ];
  };
}
