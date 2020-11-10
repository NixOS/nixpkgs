{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rootlesskit";
  version = "0.10.0";
  goPackagePath = "github.com/rootless-containers/rootlesskit";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    sha256 = "0jrzqaczd5zxlbvh0hjym8pc1d7y8c66gslq3d3l5vv4z7hz7yfr";
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
