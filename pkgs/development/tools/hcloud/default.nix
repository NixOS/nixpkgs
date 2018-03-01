{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hcloud-${version}";
  version = "1.3.0";
  goPackagePath = "github.com/hetznercloud/cli";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1216qz1kk38vkvfrznjwb65vsbhscqvvrsbp2i6pnf0i85p00pqm";
  };

  buildFlagsArray = [ "-ldflags=" "-X github.com/hetznercloud/cli.Version=${version}" ];

  meta = {
    description = "A command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    homepage = https://github.com/hetznercloud/cli;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.zauberpony ];
  };
}
