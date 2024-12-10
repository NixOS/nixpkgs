{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-5tFhk62ewRE87lxgVM2bytV9GbXT5iAwbJqklohYDvM=";
  };

  vendorHash = "sha256-Hij3lh92OCH+sTrzNl/KkjLAhPGffzzmxhPDO2wG0gA=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "json_exporter";
  };
}
