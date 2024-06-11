{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "melt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "melt";
    rev = "v${version}";
    sha256 = "sha256-AfFsw1Xjj0RsP2LOeMBDffkcqgmxsqsE1iguP/0IDtM=";
  };

  vendorHash = "sha256-Ec3RWH7I8nv6ZVYLrX0b/2RWwZ6cO4qbs0XqQemUYnE=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Backup and restore Ed25519 SSH keys with seed words";
    mainProgram = "melt";
    homepage = "https://github.com/charmbracelet/melt";
    changelog = "https://github.com/charmbracelet/melt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
