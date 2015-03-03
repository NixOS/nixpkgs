{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-02-27";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "c1bc8e610be8bf1cc8170f788a89a9ee257eb51f";
    sha256 = "1rpq7rxqmqmlaqv9aj7n2bmlw3ls55iyhcsk8kp4g9kf20f0pgym";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
