{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.3.1";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oGTtS5UlEebIqv4SM4q0YclASJNu8DNOLrGLRRAtkd8=";
  };

  patches = [
    ./use_tmpdir_on_darwin.diff
  ];

  vendorHash = "sha256-RpbnoXyTrqGOI7DpgkO+J47P17T4QCVvM1CfS6kRO9Y=";

  meta = with lib; {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
