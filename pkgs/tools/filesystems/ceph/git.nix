{ callPackage, fetchgit, git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-06-06";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "efededa0107eebd4abc0e08dd34200d6ca175626";
    sha256 = "18lcn4misyvgjh7r0vkal480x23yr8pcjwzl4k4hbrpqmm97znp9";
  };
})
