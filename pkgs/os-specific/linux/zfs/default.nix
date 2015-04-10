{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "0xlj2w6gadip3rr3f1lri1n93lkjpzyksnk01sbl5wsrbkry3xjq";
  };

  patches = [ ./nix-build.patch ];
})
