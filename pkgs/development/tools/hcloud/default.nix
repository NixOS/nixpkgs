{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.14.0";

  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "167x64ni4xm0d9b02gy8zvc8knhsvb1c9jhysw7svi7iaw5f2ds5";
  };

  modSha256 = "1g81szkrkxmv51l78v0d39i8dvrrdhf8wh38rwxvnay3iajgrnqk";

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
