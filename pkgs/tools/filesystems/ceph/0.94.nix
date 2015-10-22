{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.4";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0jp3c805bix88z3103kbrxv2yndpjcz3j5rp669f7qq46074zw6g";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
