{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.1.1";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1qvjj2iqzv2xz5037ksbk7mqjv6gsx2jsprizdzzzij3hnlricp5";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
