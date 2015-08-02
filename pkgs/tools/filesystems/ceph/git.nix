{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-31";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "ef86e29259d0e863e62115926bf67287dc9a7e41";
    sha256 = "14h387ngx3fmdm0b0sgl0l743j3d22gnp3lv68ah59yc4crfgdcx";
  };

  patches = [ ./fix-pythonpath.patch ];
})
