{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "0nhww7pbyqpiikcli1ysqa15d4y76h3jaij1j0sj8i3mhv1nsjz9";
  };

  vendorSha256 = "1fiy6x06mqxbv9c4rxfl4q7hvblbzhknkpcp0alz61f3fk5wxsgp";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
