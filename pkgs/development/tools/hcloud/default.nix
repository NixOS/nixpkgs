{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hcloud";
  version = "1.16.2";

  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0cxh92df8gdl4bmr22pdvdxdkdjyfy0jv48y0k6awy1xz61r94ap";
  };

  modSha256 = "1sdp62q4rnx7dp4i0dhnc8kzi8h6zzjdy7ym0mk9r7xkxxx0s3ds";

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
