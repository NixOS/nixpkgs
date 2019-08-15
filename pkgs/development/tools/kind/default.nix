{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  pname = "kind";
  version = "0.3.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "1azl5knw1n7g42xp92r9k7y4rzwp9xx0spcldszrpry2v4lmc5sb";
  };

  # move dev tool package that confuses the go compiler
  patchPhase = "rm -r hack";

  goDeps = ./deps.nix;
  goPackagePath = "sigs.k8s.io/kind";
  excludedPackages = "images/base/entrypoint";

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = https://github.com/kubernetes-sigs/kind;
    maintainers = with maintainers; [ offline rawkode ];
    license     = stdenv.lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
