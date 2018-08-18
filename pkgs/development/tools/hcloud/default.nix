{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hcloud-${version}";
  version = "1.6.0";
  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0iswy8xjqvshwk9w2vz3miph953qdh21xga9hl6aili84x25xzbx";
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
