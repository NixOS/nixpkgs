{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "caddy";
  version = "2.2.1";

  subPackages = [ "cmd/caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "065kxnyapjk4r07qrr55zs5w72p8rb8mapq3dh9lr1y13b8sgka9";
  };

  vendorSha256 = "1rm7v03v6rf9fdqrrl639z8a46cdzswjp8rdpygcsndqfznn5w7b";

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
