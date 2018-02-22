{ callPackage, fetchgit, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "12.2.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "01anqxyffa8l2lzgyb0dj6fjicfjdx2cq9y1klh24x69gxwkdh00";
  };

})
