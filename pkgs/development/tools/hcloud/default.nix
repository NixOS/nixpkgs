{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-cJNCp60OZBPXtda787PDT9iInxidTvzYmf9orifmS/A=";
  };

  vendorHash = "sha256-IIszQCAsNSQYieM1JQH1Dald9saUhZ2kPhwZ1p2GTp4=";

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
    mainProgram = "hcloud";
    homepage = "https://github.com/hetznercloud/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ zauberpony techknowlogick ];
  };
}
