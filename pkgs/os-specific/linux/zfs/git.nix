{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-05-13";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "7fec46b9d8967109ad289d208e8cf36a0c16e40c";
    sha256 = "0gvzw6vn7wyq2g9psv0fdars7ssidqc5l85x4yym5niccy1xl437";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
