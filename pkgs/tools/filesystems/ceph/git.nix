{ callPackage, fetchgit, git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-20";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "ce534e1e0addfe93194a553cec98799ea97affe4";
    sha256 = "19i9fp06fdyhx5x6ryw5q81id0354601yxnywvir3i9hy51p9xaz";
  };

  patches = [ ./fix-pythonpath.patch ];
})
