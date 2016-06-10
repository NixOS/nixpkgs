{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "hologram-${version}";
  version = "20160209-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "8d86e3fdcbfd967ba58d8de02f5e8173c101212e";

  goPackagePath = "github.com/AdRoll/hologram";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/AdRoll/hologram";
    sha256 = "0i0p170brdsczfz079mqbc5y7x7mdph04p3wgqsd7xcrddvlkkaf";
  };

  goDeps = ./deps.json;
}
