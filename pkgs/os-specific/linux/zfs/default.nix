{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4.2";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "192x4z5am5wgrr4hb5skshyr5a6af52xpnk6pni4hs4pxvlpcs37";
  };

  patches = [
    ./nix-build.patch
    ./compat-4.2-1.patch
    ./compat-4.2-2.patch
    ./compat-4.2-3.patch
  ];
})
