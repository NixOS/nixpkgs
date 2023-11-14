{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.38.3";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-argcQvt4875TNOX5P5sOF41u6GcFq79gnH41To73foM=";
  };

  vendorHash = "sha256-RXojFeT80oroBSweyb0eYo+LC/JTi1F3LmQ10XpnEXA=";

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

  meta = with lib; {
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${version}";
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ zauberpony techknowlogick ];
  };
}
