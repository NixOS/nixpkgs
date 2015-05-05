{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.80.9";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0c1hwl2jzghvbrnddwbp748b02jqznvigwriqx447iz2xyrz2w8q";
  };

  patches = [
    ./0001-Cleanup-boost-optionals.patch
    ./fix-pgrefdebugging.patch
  ];
})
