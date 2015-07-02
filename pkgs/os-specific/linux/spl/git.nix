{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-06-29";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "77ab5dd33a99bdf7fb062f0ea327582236a225b3";
    sha256 = "1hbn8hi305cn15nlcm9x99nczjqjkhdc38hzww11xn78py8d90w9";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
