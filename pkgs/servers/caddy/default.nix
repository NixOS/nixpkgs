{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.10.3";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "0srz1cji1z6ag591vfwjd0aypi32hr7hh9ypps8p5szf075rkr8p";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=v${version}
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://caddyserver.com;
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem fpletz ];
  };
}
