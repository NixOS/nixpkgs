{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-BmV+g0Geue41KNcB++TaoSsuGG1HA+uH5GHye7QRWOM=";
  };

  vendorHash = "sha256-eGeaH9nIjBSZLxNlsQtas122eEXrIbrGn/GYVB4KhvY=";

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
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${version}";
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zauberpony ];
  };
}
