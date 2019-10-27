{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "1.0.3";

  goPackagePath = "github.com/caddyserver/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n7i9w4vva5x5wry7gzkyfylk39x40ykv7ypf1ca3zbbk7w5x6mw";
  };
  modSha256 = "0np0mbs0mrn8scqa0dgvi7ya1707b3883prdaf1whsqrcr71ig8q";

  buildFlagsArray = ''
    -ldflags=
      -s -w -X github.com/caddyserver/caddy/caddy/caddymain.gitTag=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://caddyserver.com;
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem fpletz zimbatm ];
  };
}
