{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-03";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "6ab08667a44458f775da9f0ecceddbcea1275746";
    sha256 = "1n168kgagc6fkm9pqfwvlbqgw85z8ksjfy3bff69pi0cn1g9d739";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
