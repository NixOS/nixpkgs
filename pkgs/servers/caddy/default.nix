{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.10.11";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "04ls0s79dsyxnrpra55qvl0dk9nyvps59l034326r3bzk4jhb3q6";
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
