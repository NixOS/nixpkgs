{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hound-unstable-${version}";
  version = "20160919-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "f95e9a9224b8878b9cd8fac0afb6d31f83a65ca7";

  goPackagePath = "github.com/etsy/hound";

  src = fetchFromGitHub {
    inherit rev;
    owner = "etsy";
    repo = "hound";
    sha256 = "0d4mhka7f8x8xfjrjhl5l0v06ng8kc868jrajpv5bjkxsj71nwbg";
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
