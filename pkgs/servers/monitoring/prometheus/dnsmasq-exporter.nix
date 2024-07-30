{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dnsmasq_exporter";
  version = "unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    rev = "03f84edc208fa88e31cf00533db42e7e0c9717ca";
    hash = "sha256-YFQ4XO3vnj2Ka3D/LS5aG6WX+qOCVTlq5khDxLoQllo=";
  };

  vendorHash = "sha256-oD68TCNJKwjY3iwE/pUosMIMGOhsWj9cHC/+hq3xxI4=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dnsmasq; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Dnsmasq exporter for Prometheus";
    mainProgram = "dnsmasq_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ];
  };
}
