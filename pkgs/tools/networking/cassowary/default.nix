{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wRpITbxtn2sHw7kkQ8rnCPQCU0JS6smdQLq1Z/RyeHo=";
  };

  vendorSha256 = "sha256-b77Sje5OsysTRRbzgdLnTlLLyLIACjD4c/oS9zyI0d8=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
  };
}
