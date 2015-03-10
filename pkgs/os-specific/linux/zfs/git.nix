{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-10";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "7f3e4662832269b687ff20dafc6a33f8e1d28912";
    sha256 = "1z0aizn212m6vygp4iqd3dv2xpqb883bvz12sw6hg7w8isq83ila";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
