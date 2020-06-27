{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.17.0";

  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1brqqcyyljkdd24ljx2qbr648ihhhmr8mq6gs90n63r59ci6ksch";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "1m96j9cwqz2b67byf53qhgl3s0vfwaklj2pm8364qih0ilvifppj";

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
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
