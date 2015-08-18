{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-18";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "cf8a360cd1e3937aa1ac74fbf39790b7fb43e71f";
    sha256 = "0d8vlxap800x8gil16124nb4yvfqb5wa3pk09knrikmmwia49k9v";
  };

  patches = [ ./fix-pythonpath.patch ];
})
