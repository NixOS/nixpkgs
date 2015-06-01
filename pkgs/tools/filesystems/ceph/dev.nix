{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.0.0";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "07x5riqxh2mjcvlblv900vclgh8glnb464s6ssdcgkp31fk1gybg";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
