{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-6UQaO2ArAYd6Lr1maciC83k1GlR8FLx+acAZh6SjI3g=";
  };

  vendorHash = "sha256-mxAG3o3IY70xn8WymUzF96Q2XWwQ0efWrrw1VV4Y8HU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/hetznercloud/cli/internal/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/hcloud completion $shell > hcloud.$shell
      installShellCompletion hcloud.$shell
    done
  '';

  meta = {
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${version}";
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zauberpony ];
  };
}
