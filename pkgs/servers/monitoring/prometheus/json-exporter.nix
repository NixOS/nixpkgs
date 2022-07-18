{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-BzzDa+5YIyaqG88AZumGVEbbHomcNWhVWhSrITdD6XA=";
  };

  vendorSha256 = "sha256-Xw5xsEwd+v2f4DBsjY4q0tzABgNo4NuEtiTMoZ/pFNE=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "json_exporter";
  };
}
