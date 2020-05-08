{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "2.0.0";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c1frfx0qkprhf4var70cncvrw8s9gjag2hygndbd9055hb52bvv";
  };

  modSha256 = "19sxyvfq1bpg85w8cd1yk2s6rd8759cf2zqs5b6wyny4cak2bl83";

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
