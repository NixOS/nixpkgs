{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "caddy";
  version = "2.4.5";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/DZnIXAvhCaXFl4DvYP4LSFQQytzj6HWYsmqx5T8GNM=";
  };

  vendorSha256 = "sha256-ZevSZ8zTGtkrrJF0xvAtxCgP0CsxcORqD40LkMQ0aWc=";

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
