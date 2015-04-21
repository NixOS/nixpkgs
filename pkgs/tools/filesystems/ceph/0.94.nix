{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.1";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0rrl10vda4xv22al2c5ccd8v8drs26186dvkrxndvqz8p9999cjx";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
