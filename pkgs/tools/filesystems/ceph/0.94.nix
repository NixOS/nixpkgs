{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.1.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0ks5djgfhjpydjdlw7s940m3mlzrvz0xhhk75nqx7sbvymgcc73q";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
