{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-ySCfU/VWZz6tSZbrbhT/OIoxme+Y53eFtlVTI43yNVA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-G3kiaYoCyoltyS/OlecJHaYWpeFax1qonOJZr30wSV8=";

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
