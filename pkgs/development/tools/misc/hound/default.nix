{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hound-unstable-${version}";
  version = "20170324";
  rev = "effbe5873f329fcdf982e906b756b535e2804ebc";

  goPackagePath = "github.com/etsy/hound";

  src = fetchFromGitHub {
    inherit rev;
    owner = "etsy";
    repo = "hound";
    sha256 = "0zc769lygad5an63z5mivaggbmm07d9ynngi2jx3f7651wpji4aw";
  };

  goDeps = ./deps.nix;

  meta = {
    inherit (src.meta) homepage;

    description = "Lightning fast code searching made easy";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ grahamc ];
    platforms = stdenv.lib.platforms.unix;
  };
}
