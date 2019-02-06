{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  name = "kind-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    sha256 = "01ifmnv3jid4ls6qw9d6j9vldjbbnrwclzv8spnh6fnzb2wprln2";
  };

  goPackagePath = "sigs.k8s.io/kind";
  excludedPackages = "images/base/entrypoint";

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = https://github.com/kubernetes-sigs/kind;
    maintainers = with maintainers; [ offline rawkode ];
    license = stdenv.lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
