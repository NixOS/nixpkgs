{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles }:

with stdenv.lib;

buildGoPackage rec {
  pname = "kind";
  version = "0.7.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "0hvb0rbi1m0d1flk15l3wws96kmmjhsy6islkhy5h7jalc4k0nx4";
  };

  goDeps = ./deps.nix;
  goPackagePath = "sigs.k8s.io/kind";
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash zsh; do
      $bin/bin/kind completion $shell > kind.$shell
      installShellCompletion kind.$shell
    done
  '';

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = stdenv.lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
