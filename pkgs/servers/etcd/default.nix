{ lib, libpcap, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.13"; # After updating check that nixos tests pass
  rev = "v${version}";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "1kac4qfr83f2hdz35403f1ald05wc85vvhw79vxb431n61jvyaqy";
  };

  subPackages = [
    "cmd/etcd"
    "cmd/etcdctl"
  ];

  buildInputs = [ libpcap ];

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = https://coreos.com/etcd/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
