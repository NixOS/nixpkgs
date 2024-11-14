{ lib, buildGo122Module, fetchFromGitHub, nixosTests }:

buildGo122Module rec {
  pname = "dnsmasq_exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    rev = "v${version}";
    hash = "sha256-2sOOJWEEseWwozIyZ7oes400rBjlxIrOOtkP3rSNFXo=";
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
