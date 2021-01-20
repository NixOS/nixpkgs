{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0sjshcppcfdfz29nsrzvrciypcb4r7fbl2sqhlkcq948b7k3jk8b";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "0q6jm2ghwrbjxn76i8wz72xjdmwfvl5dn8n4zilyjjx9vvllwdjw";

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
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
