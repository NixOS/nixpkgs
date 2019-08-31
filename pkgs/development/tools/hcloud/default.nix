{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "hcloud";
  version = "1.13.0";

  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1bin9gcmmj3i6a11rv7czvnryl8bv7cjz3pi2cqx8baycg3hia5j";
  };

  goDeps = ./deps.nix;

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
    homepage = "https://github.com/hetznercloud/cli";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
