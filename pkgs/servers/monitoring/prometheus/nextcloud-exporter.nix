{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-73IxGxnKgbG50nr57Wft+hh0KT7redrwXc4EZFn25qs=";
  };

  vendorSha256 = "sha256-vIhHUFg8m6raKF82DcXRGKCgSM2FJ2VTM+MdMjP7KUY=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.unix;
  };
}
