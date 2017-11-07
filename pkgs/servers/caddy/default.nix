{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.10.10";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "1x7f1yz5vnsy9n50ak0vjrm4w8fqc1qvhv8fmqnsc8cgbp7f3p8w";
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
