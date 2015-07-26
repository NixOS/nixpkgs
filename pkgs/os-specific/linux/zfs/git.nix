{ callPackage, stdenv, fetchFromGitHub, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-21";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "3b79cef21294f3ec46c4f71cc5a68a75a4d0ebc7";
    sha256 = "01l4cg62wgn3wzasskx2nh3a4c74vq8qcwz090x8x1r4c2r4v943";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
