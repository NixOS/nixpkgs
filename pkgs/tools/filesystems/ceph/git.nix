{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-11";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "78de6fd61d5c0422f18c2f683b2cc489f3cbb4d3";
    sha256 = "1kbrsr6vzvprcdq0hg7cgcmvqc61w3i1yzgrmjdmy3jcsmc979xi";
  };

  patches = [ ./fix-pythonpath.patch ];
})
