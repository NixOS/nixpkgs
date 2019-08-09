{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage
rec {
  pname = "cri-tools";
  version = "1.14.0";
  src = fetchFromGitHub {
    owner = "kubernetes-incubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v5i7shbn7b6av1d2z6r5czyjdll9i7xim9975lpnz1136xb6li7";
  };

  goPackagePath = "github.com/kubernetes-incubator/cri-tools";
  subPackages = [ "cmd/crictl" "cmd/critest" ];

  meta = {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = https://github.com/kubernetes-sigs/cri-tools;
    license = lib.licenses.asl20;
  };
}

