{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.11.1";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "0v35d3dy0f88wgk1vzznbx7p15vjjf7xm3qfi2c3192rsxgzvy0l";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://caddyserver.com;
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem fpletz zimbatm ];
  };
}
