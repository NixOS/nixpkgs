{ callPackage, fetchurl, fetchpatch }:

callPackage ./generic.nix (rec {
  version = "1.7";
  src = fetchurl {
    url = "https://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "091c0b5bca57d4aa20be20e826ec161efe3aec9c788fbbcf3806a734a517f0f3";
  };
  patches = [
    # follow redirect in nixos-infect. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/NixOS/nixops/commit/fb6d4665e8efd858a215bbaaf079ec3f5ebc49b8.patch";
      sha256 = "1hbhykl811zsqlaj3y5m9d8lfsal6ps6n5p16ah6lqy2s18ap9d0";
    })
  ];
})
