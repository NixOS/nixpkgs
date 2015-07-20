{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.80.10";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1arajccczjdqp7igs17569xlq5cj4azcm5wwixg6ryypjr2grcbl";
  };

  patches = [
    ./0001-Cleanup-boost-optionals.patch
    ./fix-pgrefdebugging.patch
    ./boost-158.patch
  ];
})
