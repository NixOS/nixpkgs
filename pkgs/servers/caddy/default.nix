{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.10.4";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "0zch19a38487dflx84dlkwz67by9g4v2v8d7wrslqhs14a0sifhk";
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
