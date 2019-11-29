{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rootlesskit";
  version = "0.3.0-alpha.2";
  goPackagePath = "github.com/rootless-containers/rootlesskit";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    sha256 = "11y4hcrpayyyi9j3b80ilccxs5bbwnqfpi5nsjgmjb9v01z35fw6";
  };

  meta = with lib; {
    homepage = https://github.com/rootless-containers/rootlesskit;
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
