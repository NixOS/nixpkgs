{ stdenv, buildGoModule, fetchFromGitHub }:

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

  vendorSha256 = "1m96j9cwqz2b67byf53qhgl3s0vfwaklj2pm8364qih0ilvifppj";

  buildFlagsArray = [ "-ldflags=" "-w -X github.com/hetznercloud/cli/cli.Version=${version}" ];

  postInstall = ''
    mkdir -p \
      $out/etc/bash_completion.d \
      $out/share/zsh/vendor-completions

    # Add bash completions
    $out/bin/hcloud completion bash > "$out/etc/bash_completion.d/hcloud"

    # Add zsh completions
    echo "#compdef hcloud" > "$out/share/zsh/vendor-completions/_hcloud"
    $out/bin/hcloud completion zsh >> "$out/share/zsh/vendor-completions/_hcloud"
  '';

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = "https://github.com/hetznercloud/cli";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}