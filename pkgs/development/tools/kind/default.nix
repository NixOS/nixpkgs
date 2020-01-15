{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  pname = "kind";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "12bjvma98dlxybqs43dggnd6cihxm18xz68a5jw8dzf0cg738gs8";
  };

  goDeps = ./deps.nix;
  goPackagePath = "sigs.k8s.io/kind";
  subPackages = [ "." ];

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = https://github.com/kubernetes-sigs/kind;
    maintainers = with maintainers; [ offline rawkode ];
    license     = stdenv.lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
