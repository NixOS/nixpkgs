{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-gEXQaVBzvOifnCN8TWfadTgypHy+u7lZw+qoyW+mEKU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-SURFlHCrWqTjdHO9ZUmtR2nmKwt0S7rpA6jQ0dDD/EE=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/hetznercloud/cli/cli.Version=${version}" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/hcloud completion $shell > hcloud.$shell
      installShellCompletion hcloud.$shell
    done
  '';

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zauberpony ];
  };
}
