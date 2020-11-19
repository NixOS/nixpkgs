{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rootlesskit";
  version = "0.11.0";
  goPackagePath = "github.com/rootless-containers/rootlesskit";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    sha256 = "1x5f02yw5bzkjwg7lcsa7549d8fj13dnk596rgg90q0z6vqfarzj";
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
