{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "rootlesskit";
  version = "0.11.1";
  goPackagePath = "github.com/rootless-containers/rootlesskit";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    sha256 = "15k0503077ang9ywvmhpr1l7ax0v3wla0x8n6lqpmd71w0j2zm5r";
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
