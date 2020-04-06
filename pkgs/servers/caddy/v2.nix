{ stdenv, callPackage, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "2.0.0-rc.1";

  goPackagePath = "github.com/caddyserver/caddy";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ir394nmdrqvslghqky4d2py65ff77fqsp0nmxdlsdps49szwh7h";
  };
  modSha256 = "0sqnw81l73gssnpd4dsl3vd10584riq0417z4dvbhjnc8b3z4xwv";

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
