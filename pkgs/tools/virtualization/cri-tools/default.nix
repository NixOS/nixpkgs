{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "cri-tools";
  version = "1.17.0";
  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h9gry56graif761lmcy91q9fzwvmwb15wcx8245927yfg5j0zgh";
  };

  goPackagePath = "github.com/kubernetes-sigs/cri-tools";

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make all install BINDIR=$bin/bin
  '';

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = https://github.com/kubernetes-sigs/cri-tools;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
  };
}
