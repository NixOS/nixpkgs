{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  name = "kube-aws-${version}";
  version = "0.9.4";

  goPackagePath = "github.com/coreos/kube-aws";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "kube-aws";
    rev = "v${version}";
    sha256 = "11h14fsnflbx76rmpp0fxahbxi2qgcamgyxy9s4rmw83j2m8csxp";
  };

  preBuild = ''(
    cd go/src/${goPackagePath}
    go generate ./core/controlplane/config
    go generate ./core/nodepool/config
    go generate ./core/root/config
  )'';

  buildFlagsArray = ''
    -ldflags=-X github.com/coreos/kube-aws/core/controlplane/cluster.VERSION=v${version}
  '';

  meta = {
    description = "Tool for deploying kubernetes on aws using coreos";
    license = licenses.asl20;
    homepage = https://github.com/coreos/coreos-kubernetes;
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
