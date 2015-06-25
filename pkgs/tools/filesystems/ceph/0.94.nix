{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1nhqzmxv7bz93b8rbd88wgmw9icm2lhmc94dfscgh23kfpipyd6l";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
