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
  vendorSha256 = "09vnci9pp8zp7bvn8zj68wslz2nc54nhcd0ll31sqfjbp00215mj";

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