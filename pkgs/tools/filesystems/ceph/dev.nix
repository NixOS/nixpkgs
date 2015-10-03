{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.0.3";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "08ccy735srzmi505qlrpqdh5js40mpd5k1vdhnysknra0vqlpmdx";
  };

  patches = [
    ./fix-pythonpath.patch
    ./9.0.3-i686-fix.patch
  ];
})
