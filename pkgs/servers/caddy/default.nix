{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.9.2";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "1nmimyykbjfnwbrka50z15d11z0fc6abpkr0cjbj678d5r9wpz33";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=${version}
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://caddyserver.com;
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
