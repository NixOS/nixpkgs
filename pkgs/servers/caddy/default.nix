{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "1.0.4";

  goPackagePath = "github.com/caddyserver/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mqbaa9cshrqm5fggm5l5nzcnv8c9dvylcc4z7qj3322vl5cpfdc";
  };
  modSha256 = "0f08smcnzmrj3v43v0qgyd11qwdbymbl86c9prais6sykgh1ld97";

  preBuild = ''
    cat << EOF > caddy/main.go
    package main
    import "github.com/caddyserver/caddy/caddy/caddymain"
    func main() {
      caddymain.EnableTelemetry = false
      caddymain.Run()
    }
    EOF
  '';

  meta = with stdenv.lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem fpletz zimbatm filalex77 ];
  };
}
