{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  name = "kind-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    sha256 = "1jldj864ip8hrk3zhkjifr4gzgc8kxmxxwvklxglymhv8cxc179f";
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
