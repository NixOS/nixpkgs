{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-24";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "62e2eb2329d99f7c39bcda47bc9ecb2887608fa5";
    sha256 = "1i59sps2y0mgm9sj4a0h03xl0hlgiym4637j5j6zc5g125zzcnrd";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
