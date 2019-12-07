{ stdenv, callPackage, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "2.0.0-beta10";

  goPackagePath = "github.com/caddyserver/caddy";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vagcw6ibri4nbx1n60xp7rffcfr64a2202hjaijyjzc8wcl80na";
  };
  modSha256 = "1sb8w6n84cpya2rjm0zm798kzf5vjpkr5440j1gfnnnr07jl2aqn";

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
