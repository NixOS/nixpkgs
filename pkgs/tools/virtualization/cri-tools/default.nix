{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage
rec {
  pname = "cri-tools";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "kubernetes-incubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "03fhddncwqrdyxz43m3bak9dlrsqzibqqja3p94nic4ydk2hry62";
  };

  goPackagePath = "github.com/kubernetes-incubator/cri-tools";
  subPackages = [ "cmd/crictl" "cmd/critest" ];

  meta = {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = https://github.com/kubernetes-sigs/cri-tools;
    license = lib.licenses.asl20;
  };
}

