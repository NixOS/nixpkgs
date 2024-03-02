{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sshportal";
  version = "1.19.5";

  src = fetchFromGitHub {
    owner = "moul";
    repo = "sshportal";
    rev = "v${version}";
    sha256 = "sha256-XJ8Hgc8YoJaH2gYOvoYhcpY4qgasgyr4M+ecKJ/RXTs=";
  };

  ldflags = [ "-X main.GitTag=${version}" "-X main.GitSha=${version}" "-s" "-w" ];

  vendorHash = "sha256-4dMZwkLHS14OGQVPq5VaT/aEpHEJ/4b2P6q3/WiDicM=";

  meta = with lib; {
    description = "Simple, fun and transparent SSH (and telnet) bastion server";
    homepage = "https://manfred.life/sshportal";
    license = licenses.asl20;
    maintainers = with maintainers; [ zaninime ];
    mainProgram = "sshportal";
  };
}
