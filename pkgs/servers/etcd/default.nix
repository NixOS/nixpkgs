{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "etcd-${version}";
  version = "3.1.6"; # After updating check that nixos tests pass
  rev = "v${version}";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "1qgi6zxnijzr644w2da2gbn3gw2qwk6a3z3qmdln0r2rjnm70sx0";
  };

  subPackages = [
    "cmd/etcd"
    "cmd/etcdctl"
    "cmd/tools/benchmark"
    "cmd/tools/etcd-dump-db"
    "cmd/tools/etcd-dump-logs"
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
