{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles }:

with stdenv.lib;

buildGoPackage rec {
  pname = "kind";
  version = "0.6.1";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "165nwkhsa12z043rvkdf977jndhp82x7sccqfy75pkx99mzz43r2";
  };

  goDeps = ./deps.nix;
  goPackagePath = "sigs.k8s.io/kind";
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $bin/bin/kind completion bash > kind.bash
    $bin/bin/kind completion zsh > kind.zsh
    installShellCompletion kind.{bash,zsh}
  '';

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = https://github.com/kubernetes-sigs/kind;
    maintainers = with maintainers; [ offline rawkode ];
    license     = stdenv.lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
