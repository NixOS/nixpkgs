{ lib, fetchFromGitHub, buildGoPackage, nixosTests }:

buildGoPackage rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "1xpc6q6zp92ckkyd24cfl65vyzjv60qwh44ys6mza4k6yrxhacv4";
  };

  goPackagePath = "github.com/xperimental/nextcloud-exporter";

  goDeps = ./nextcloud-exporter-deps.nix;

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers.";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.unix;
  };
}
