{ lib, buildGoPackage, fetchFromGitHub, docker }:

buildGoPackage rec {
  rev = "3057a2c07061c8d9ffaf77e5442ffd7512ac0133";
  pname = "heapster";
  version = lib.strings.substring 0 7 rev;
  goPackagePath = "k8s.io/heapster";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "kubernetes";
    repo = "heapster";
    sha256 = "1vg83207y7yigydnnhlvzs3s94vx02i56lqgs6a96c6i3mr3ydpb";
  };

  preBuild = ''
    export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace
  '';

  meta = with lib; {
    description = "Compute Resource Usage Analysis and Monitoring of Container Clusters";
    license = licenses.asl20;
    homepage = "https://github.com/kubernetes/heapster";
    maintainers = with maintainers; [ offline ];
    platforms = docker.meta.platforms;
  };
}
