{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.80.10";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    leaveDotGit = true;
    sha256 = "0s81j6yj8y27hlx1hid9maz0l7bhjjskjxzxlhsikzmdc1j27m4r";
  };

  patches = [
    ./0001-Cleanup-boost-optionals.patch
    ./fix-pgrefdebugging.patch
    ./boost-158.patch
  ];
})
