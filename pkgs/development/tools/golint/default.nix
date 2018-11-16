{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "lint-${version}";
  version = "20180208-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "e14d9b0f1d332b1420c1ffa32562ad2dc84d645d";
  
  goPackagePath = "github.com/golang/lint";
  excludedPackages = "testdata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/golang/lint";
    sha256 = "15ynf78v39n71aplrhbqvzfblhndp8cd6lnknm586sdl81wama6p";
  };

  goDeps = ./deps.nix;
}
