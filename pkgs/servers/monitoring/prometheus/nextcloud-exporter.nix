{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-S8r9WXWKneik+r6gdwWdDOWXpNkqr9aVem76Jmdligg=";
  };

  vendorHash = "sha256-isT/ntUnixB76WxnMm/5TUd9JeaCy7vkCwVtkc95o2M=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "nextcloud-exporter";
  };
}
