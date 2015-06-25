{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.0.1";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1sq6gim7dik04lih5krwm4qpnf2blby3xj2vz9n4cknjnj0dbg7x";
  };
})
