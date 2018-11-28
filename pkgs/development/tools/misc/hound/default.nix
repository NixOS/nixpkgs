{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hound-unstable-${version}";
  version = "2018-11-02";
  rev = "74ec7448a234d8d09e800b92e52c92e378c07742";

  goPackagePath = "github.com/etsy/hound";

  src = fetchFromGitHub {
    inherit rev;
    owner = "etsy";
    repo = "hound";
    sha256 = "0g6nvgqjabprcl9z5ci5frhbam1dzq978h1d6aanf8vvzslfgdpq";
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
