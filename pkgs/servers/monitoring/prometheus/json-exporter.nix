{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-Zeq4gbwGd16MkGQRL8+bq0Ns06Yg+H9GAEo3qaMGDbc=";
  };

  vendorHash = "sha256-41JsxA3CfQjiwZw/2KP4Re4g3gmexadHuN0lUP5rjdo=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "Prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "json_exporter";
  };
}
