{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "caddy";
  version = "2.3.0";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "03cbbr8z9g156lgx7pyn1p1i4mh8ayhhhv24r1z3h1vgq6y4ka7r";
  };

  vendorSha256 = "0gpzxjiyv7l1nibh1gas4mvinamiyyfgidd8cy4abz95v6z437lp";

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
