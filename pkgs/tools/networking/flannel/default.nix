{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "flannel-${version}";
  version = "0.5.5";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/coreos/flannel";
    sha256 = "19nrilcc41411rag2qm22vdna4kpqm933ry9m82wkd7sqzb50fpw";
  };
}
