{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "melt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "melt";
    rev = "v${version}";
    sha256 = "sha256-C5bvlgyHU4lfmaAjNddnVyB2B41Wq7yO/RmARAeaORw=";
  };

  vendorSha256 = "sha256-9LTR7CrTBGAh7TPMQenY4vZQ7KMYv02fDsY51pkJZSo=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Backup and restore Ed25519 SSH keys with seed words";
    homepage = "https://github.com/charmbracelet/melt";
    changelog = "https://github.com/charmbracelet/melt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
