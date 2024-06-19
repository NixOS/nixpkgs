{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-tbzXxrAzMZyyePeI+Age31+XJFJcp+1RqoCAGCKaLmQ=";
  };

  vendorHash = "sha256-9ABGc5uSOIjhKcnTH5WOuwg0kXhFsxOlAkatcOQy3dg=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
  };
}
