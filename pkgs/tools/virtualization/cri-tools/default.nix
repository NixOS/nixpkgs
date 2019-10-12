{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "cri-tools";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "03fhddncwqrdyxz43m3bak9dlrsqzibqqja3p94nic4ydk2hry62";
  };

  goPackagePath = "github.com/kubernetes-sigs/cri-tools";

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make
  '';

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = https://github.com/kubernetes-sigs/cri-tools;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
  };
}
