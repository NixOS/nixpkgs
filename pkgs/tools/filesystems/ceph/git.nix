{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-07";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "dcd6e96495d949066962d1c7e18a9d4188b0fa37";
    sha256 = "1w62xfbcdx2q5wjz2bqlhn4bb1iag8xyhgjc2nklqk7py9lif16m";
  };

  patches = [ ./fix-pythonpath.patch ];
})
