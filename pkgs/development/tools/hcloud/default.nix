{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0iq04jfqvmwlm6947kzz4c3a33lvwxvj42z179rc3126b5v7bq54";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "1svwrb5wyz5d8fgx36bpypnfq4hmpfxyd197cla9wnqpbkia7n5r";

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
