{ callPackage, fetchgit, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "12.2.7";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "031nfw2g2fdpxxx39g862phgmdx68hj9r54axazandghfhc1bzrl";
  };

})
