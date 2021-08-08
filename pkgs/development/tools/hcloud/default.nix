{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-fKekn930nOGYUhkQus9p4sKcsuUks+KfO4+X5C/3nWg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-yPRtqJTmYDqzwHyBmVV4HxOmMe7FuSZ/lsQj8PInhFg=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/hetznercloud/cli/cli.Version=${version}" ];

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
