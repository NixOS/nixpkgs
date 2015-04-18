{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-08";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "cd69f020e4b0f9c416dd07a264e48c9488a7633f";
    sha256 = "1fy5zlh8cs65s52vixkp00ihrlrhs2frd6vwxwjqmpzyb7fnh3m8";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
