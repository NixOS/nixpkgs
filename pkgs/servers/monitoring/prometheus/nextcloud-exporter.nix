{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-lK5a63ZokFlm5S3k1a0MGBm+vAAqQV/5ERjJ0zZ4Yno=";
  };

  vendorHash = "sha256-9+Vv2GodEocDppWvTj4W3/tBqSJJZ9LkyTl5evm/45Y=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nextcloud-exporter";
  };
}
