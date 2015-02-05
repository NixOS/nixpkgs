{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.4.5";
  name = "etcdctl-${version}";
  goPackagePath = "github.com/coreos/etcdctl";
  src = fetchFromGitHub {
    owner = "coreos";
    repo = "etcdctl";
    rev = "v${version}";
    sha256 = "1kbri59ppil52v7s992q8r6i1zk9lac0s2w00z2lsgc9w1z59qs0";
  };

  dontInstallSrc = true;

  meta = with lib; {
    description = "A simple command line client for etcd";
    homepage = http://coreos.com/using-coreos/etcd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
