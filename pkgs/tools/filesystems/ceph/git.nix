{ callPackage, fetchgit, git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-05-29";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "64096b870960d021ab5001b6a5cf3a999a9abeb7";
    sha256 = "18lcn4misyvgjh7r0vkal480x23yr8pcjwzl4k4hbrpqmm97znp9";
  };
})
