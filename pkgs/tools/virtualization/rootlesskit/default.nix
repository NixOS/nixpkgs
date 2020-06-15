{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rootlesskit";
  version = "0.9.5";
  goPackagePath = "github.com/rootless-containers/rootlesskit";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    sha256 = "0l41khr4zhhsx1i8bpdji00i6bvfigs0ygfpkci0746sbplcldgj";
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
