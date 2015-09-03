{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-29";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "54626351679fe312d5b96cc0304755ae5f1ece40";
    sha256 = "12rdp1q7arxhg259y08pzix22yjlrjs5qmwv342qcl5xbfkg502r";
  };

  patches = [ ./fix-pythonpath.patch ];
})
