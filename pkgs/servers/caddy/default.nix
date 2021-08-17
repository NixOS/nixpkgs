{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "caddy";
  version = "2.4.3";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z3BVx7gCkls5Hy+H6lA3DOBequRutwa2F34FDt9n+8I=";
  };

  vendorSha256 = "sha256-Zwpakw/vyDVngc1Bn+RdRPECNweruwGxsT4dfvMELkQ=";

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
