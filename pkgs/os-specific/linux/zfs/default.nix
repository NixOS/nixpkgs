{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.5.1";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "0lbii5kc3b68zj8mvvznl05czwdkr0ld3a2javbkngfvrcn09rz2";
  };

  patches = [ ./nix-build.patch ];
})
