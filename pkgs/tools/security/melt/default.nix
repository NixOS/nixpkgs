{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "melt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "melt";
    rev = "v${version}";
    sha256 = "sha256-HambmUodAwgi1/r/Nj7P7gXNK5pyBO3omMZ9ZvSK7cc=4";
  };

  vendorSha256 = "sha256-1f3QBbWaTiplEp/4ihds1PwrEnoq/81TzlT46TufGFs=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Backup and restore Ed25519 SSH keys with seed words";
    homepage = "https://github.com/charmbracelet/melt";
    changelog = "https://github.com/charmbracelet/melt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
