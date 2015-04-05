{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-03";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "ae26dd003911277e0c7134b3e4e3a41c300a2fd5";
    sha256 = "0wq1raz68b9msbn00q1zg89rm5l7l2018k7m31s4b4gj17w38h5b";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
