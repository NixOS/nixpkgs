{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-06-22";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "72540ea3148a2bc03860d7d59b2b5fdc9a5cdee7";
    sha256 = "0428xg5whr7y7r6r1jcfk8q944j948vj2nnzwgsx7cgn3n3v1yyn";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
