{ lib, buildGoModule, fetchFromGitHub, nixosTests }:
let
  version = "2.4.6";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    sha256 = "sha256-EXs+LNb87RWkmSWvs8nZIVqRJMutn+ntR241gqI7CUg=";
  };
in
buildGoModule {
  pname = "caddy";
  inherit version;

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "sha256-xNCxzoNpXkj8WF9+kYJfO18ux8/OhxygkGjA49+Q4vY=";
  };

  vendorSha256 = "sha256-NomgHqIiugSISbEtvIbJDn5GRn6Dn72adLPkAvLbUQU=";

  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"
  '';

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
