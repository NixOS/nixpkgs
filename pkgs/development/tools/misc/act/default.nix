{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.31";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6JMWt6svJwW7FNn2sOSUjFtXBqmC02uFEiybj5H9wTw=";
  };

  vendorSha256 = "sha256-caFM1A4SGZ8MIIoWnzBdKJOAgzscrf9eGtv/GCSfzag=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
  };
}
