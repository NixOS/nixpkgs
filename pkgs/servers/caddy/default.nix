{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "caddy";
  version = "1.0.0";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "08hknms0lg5c6yhkz9g1i32d11xch2kqkjbk4w4kd1f1xpa6jvmz";
  };
  modSha256 = "02cb3swc180kh5vc2s5w8a6vidvw768l9bv5zg8zya183wzvfczs";

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
