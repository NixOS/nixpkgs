{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-usHBlfEym39p8S6w2eNeXVKpqxlJxLCn9DwK2J1AqdI=";
  };

  vendorHash = "sha256-vytfRa4eiF53VTR50l/J2Df587u8xx3lj1QhMYSqglk=";

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
