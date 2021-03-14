{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "1aabvd75a2223x5wnbyryigj7grw6l05jhr3g3s97b1f1hfigz6d";
  };

  vendorSha256 = "03kb0gklq08krl7qnvs7267siw1pkyy346b42dsk1d9gr5302wsw";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
