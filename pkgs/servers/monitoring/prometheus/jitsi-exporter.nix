{ lib, buildGoModule, fetchgit, nixosTests }:

buildGoModule rec {
  pname = "jitsiexporter";
  version = "0.2.18";

  src = fetchgit {
    url = "https://git.xsfx.dev/prometheus/jitsiexporter";
    rev = "v${version}";
    sha256 = "1cf46wp96d9dwlwlffcgbcr0v3xxxfdv6il0zqkm2i7cfsfw0skf";
  };

  vendorSha256 = null;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) jitsi; };

  meta = with lib; {
    description = "Export Jitsi Videobridge metrics to Prometheus";
    homepage = "https://git.xsfx.dev/prometheus/jitsiexporter";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
