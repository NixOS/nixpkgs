{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "go-packr-${version}";
  version = "v1.13.7";
  rev = "5a2cbb54c4e7d482e3f518c56f1f86f133d5204f";

  goPackagePath = "github.com/gobuffalo/packr";

  goDeps = ./deps.nix;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/gobuffalo/packr";
    sha256 = "0hs62w1bv96zzfqqmnq18w71v0kmh4qrqpkf2y8qngvwgan761gd";
  };

  meta = with stdenv.lib; {
    platforms   = platforms.all;
  };
}
