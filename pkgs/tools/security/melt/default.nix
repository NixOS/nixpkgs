{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "melt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "melt";
    rev = "v${version}";
    sha256 = "sha256-LKHAVVzVhHlYRDgQCIQDQ8MLnTzxsKo198BITdHjTDA=";
  };

  vendorHash = "sha256-xTisSPACxuBrv0R2GYinFGYNXD0zoCD8DFkirdc9gIE=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Backup and restore Ed25519 SSH keys with seed words";
    homepage = "https://github.com/charmbracelet/melt";
    changelog = "https://github.com/charmbracelet/melt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
