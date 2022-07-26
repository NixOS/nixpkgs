{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-mbMrXPQg5yUhmfJ3ztrXD/NKmwJKkZFFPu+utrsaPEc=";
  };

  vendorSha256 = "sha256-++uvg/vXRX2lPU4CmqAcLWbsWBXZHXaXO4qXEaq90T4";

  ldflags = [
    "-s" "-w"
    "-X github.com/hetznercloud/cli/internal/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
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
