{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-/EwQSxYDaf7B8A48aelf1yYbM7Vw6ntoz1VuYM2HDEc=";
  };

  vendorSha256 = "sha256-b05N5TXsRHD8h3q+ckxaVizq+A7VqkDWOSb0LOMGCHM=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
    platforms = platforms.unix;
  };
}
