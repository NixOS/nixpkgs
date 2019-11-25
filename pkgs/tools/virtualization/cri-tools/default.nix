{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "cri-tools";
  version = "1.16.1";
  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kpbs9dxwhlmqdqrmsqhp03qs4s7dl8b86lkmg066sicdaw433fn";
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
