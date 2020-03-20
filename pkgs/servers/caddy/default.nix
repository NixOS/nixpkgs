{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "1.0.5";

  goPackagePath = "github.com/caddyserver/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jrhwmr6gggppskg5h450wybzkv17iq69dgw36hd1dp56q002i7g";
  };
  modSha256 = "1gc0xvsihr4zp7hkrdfrplvzkaphz1y4q53rgwn2jhd8s98l57an";

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
