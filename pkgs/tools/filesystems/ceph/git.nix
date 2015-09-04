{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-04";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "8c17e0197481205f8726b06d57313ffe08fba2bf";
    sha256 = "189l412m6x0f0mqzhgzwfa3sgm5xfxzb9synlvbfm3n1fgdhj5iy";
  };

  patches = [ ./fix-pythonpath.patch ];
})
