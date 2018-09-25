{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hcloud-${version}";
  version = "1.6.1";
  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0v5n7y8vb23iva51kb15da198yk7glc1fix193icrk3pvcbj5bjr";
  };

  buildFlagsArray = [ "-ldflags=" "-w -X github.com/hetznercloud/cli/cli.Version=${version}" ];

  postInstall = ''
    mkdir -p \
      $bin/etc/bash_completion.d \
      $bin/share/zsh/vendor-completions

    # Add bash completions
    $bin/bin/hcloud completion bash > "$bin/etc/bash_completion.d/hcloud"

    # Add zsh completions
    echo "#compdef hcloud" > "$bin/share/zsh/vendor-completions/_hcloud"
    $bin/bin/hcloud completion zsh >> "$bin/share/zsh/vendor-completions/_hcloud"
  '';

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = https://github.com/hetznercloud/cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
