{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-B5L4vK5JkcYHqdyxAsP+tBcA6PtM2Gd4JwtW5nMuIXQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-3YU6vAIzTzkEwyMPH4QSUuQ1PQlrWnfRRCA1fHMny48=";

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
