{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-25";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "a4f54cf036d9a966ff87abe9a0063f2b457c2389";
    sha256 = "0n10icwmnx3y6201fncswhd1mfvs6xyk8praj27z0wnzxs1i4k96";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
