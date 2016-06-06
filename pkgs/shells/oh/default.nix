{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "oh-${version}";
  version = "20160522-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "0daaf4081475fb9d6b3801c85019bdd57b2ee9b4";

  goPackagePath = "github.com/michaelmacinnis/oh";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/michaelmacinnis/oh";
    sha256 = "0ajidzs0aisbw74nri9ks6sx6644nmwkisc9mvxm3f89zmnlsgwr";
  };

  goDeps = ./deps.json;
}
