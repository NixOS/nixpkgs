{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "prometheus-json-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "json_exporter";
    rev = "v${version}";
    sha256 = "sha256-6Uttw4Z1RCQ1kEFGJQc0x5NWgsLah0jZjPFiv+7hHFo=";
  };

  vendorSha256 = "sha256-9+nOy3TDBfOpApfdaSf8i64NDybU9UxY2qvjakA3Pro=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) json; };

  meta = with lib; {
    description = "A prometheus exporter which scrapes remote JSON by JSONPath";
    homepage = "https://github.com/prometheus-community/json_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
