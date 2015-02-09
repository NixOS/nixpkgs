{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "086476f";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "086476f92005506cb07e75f889e8ddb69026e842";
    sha256 = "1n3cjdwxccvcns7jydgznkb6jy0p59qx1yg512jjf4m9hf5p2pwm";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
