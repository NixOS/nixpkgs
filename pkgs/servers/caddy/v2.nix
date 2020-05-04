{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "2.0.0-rc.3";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jsjh8q5wsnp7j7r1rlnw0w4alihpcmpmlpqncmhik10f6v7xm3y";
  };

  modSha256 = "0n0k0w9y2z87z6m6j3sxsgqn9sm82rdcqpdck236fxj23k4akyp6";

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
