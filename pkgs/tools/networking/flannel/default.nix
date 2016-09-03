{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "flannel-${version}";
  version = "0.5.5";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "flannel";
    sha256 = "19nrilcc41411rag2qm22vdna4kpqm933ry9m82wkd7sqzb50fpw";
  };
}
