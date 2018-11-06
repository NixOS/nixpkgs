{ callPackage, fetchurl, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "13.2.2";

  src = fetchurl {
    url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    sha256 = "0h483n9iy0fkbqrhf7k0dzspwdpcaswkjwmc5n5c600fr6s1v9pk";
  };

})
