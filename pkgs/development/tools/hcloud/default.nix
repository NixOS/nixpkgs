{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.47.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-bIrkX/udxkHA+DWQ1t7QkHOmEhqacdtVR9wBWaS820M=";
  };

  vendorHash = "sha256-fNcyIP6q54A+TlsN0xliQGONx7H20KNY+d0NxOUSxQc=";

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
    description = "Command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    mainProgram = "hcloud";
    homepage = "https://github.com/hetznercloud/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ zauberpony techknowlogick ];
  };
}
