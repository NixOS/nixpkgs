{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.29.4";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-c6BVd/lt6M2gh7V4JfIQhFd97LULegFt8XTy48eLaUU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-iJnjmfP9BcT+OXotbS2+OSWGxQaMXwdlR1WTi04FesM=";

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
