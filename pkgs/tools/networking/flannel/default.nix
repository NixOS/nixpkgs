{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.1.0";
  name = "flannel-${version}";
  goPackagePath = "github.com/coreos/flannel";
  src = fetchFromGitHub {
    owner = "coreos";
    repo = "flannel";
    rev = "v${version}";
    sha256 = "1f7x6a2c8ix6j5y1r0dq56b58bl2rs2ycbdqb9fz5zv1zk2w20rd";
  };

  dontInstallSrc = true;

  meta = with lib; {
    description = "Flannel is an etcd backed network fabric for containers";
    homepage = https://github.com/coreos/flannel;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
