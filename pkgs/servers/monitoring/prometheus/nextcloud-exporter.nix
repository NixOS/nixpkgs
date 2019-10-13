{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage {
  pname = "prometheus-nextcloud-exporter";
  version = "unstable-2019-10-12";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "215c8b6b2daa3125798d883fe222bc419240e7ab";
    sha256 = "1xpc6q6zp92ckkyd24cfl65vyzjv60qwh44ys6mza4k6yrxhacv4";
  };

  goPackagePath = "github.com/xperimental/nextcloud-exporter";

  goDeps = ./nextcloud-exporter-deps.nix;

  doCheck = true;

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers.";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.unix;
  };
}
