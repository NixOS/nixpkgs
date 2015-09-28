{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-22";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "f1ead76f80cc3d078778080c35a6427256874062";
    sha256 = "16c01b9v04slp80dlgw8n9a5ndjqxi6lv0pnklh1ykh4xb248gjh";
  };

  patches = [ ./fix-pythonpath.patch ];
})
