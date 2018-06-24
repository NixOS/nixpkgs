{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hcloud-${version}";
  version = "1.5.0";
  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1pbfa977ihqn7j3ynyqghxjw0wmq0vgha4lsshdpf5xr2n3w0r8l";
  };

  buildFlagsArray = [ "-ldflags=" "-w -X github.com/hetznercloud/cli/cli.Version=${version}" ];

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = https://github.com/hetznercloud/cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
