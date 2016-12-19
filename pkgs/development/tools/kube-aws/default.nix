{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  name = "kube-aws-${version}";
  version = "0.8.1";

  goPackagePath = "github.com/coreos/coreos-kubernetes";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "coreos-kubernetes";
    rev = "v${version}";
    sha256 = "067nc525km0f37w5km44fs5pr22a6zz3lkdwwg2akb4hhg6f45c2";
  };

  preBuild = ''
    (cd go/src/github.com/coreos/coreos-kubernetes
     go generate multi-node/aws/pkg/config/config.go)
  '';

  meta = {
    description = "Tool for deploying kubernetes on aws using coreos";
    license = licenses.asl20;
    homepage = https://github.com/coreos/coreos-kubernetes;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
