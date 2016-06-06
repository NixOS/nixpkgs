{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "serf-${version}";
  version = "20150515-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "668982d8f90f5eff4a766583c1286393c1d27f68";

  goPackagePath = "github.com/hashicorp/serf";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hashicorp/serf";
    sha256 = "1h05h5xhaj27r1mh5zshnykax29lqjhfc0bx4v9swiwb873c24qk";
  };

  goDeps = ./deps.json;
}
