{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  name = "kind-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    rev    = "${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "14ddhml9rh7x4j315fb332206xbn1rzx3i0ngj3220vb6d5dv8if";
  };

  # move dev tool package that confuses the go compiler
  patchPhase = "rm -r hack";

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
