{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-23";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "f7bda9567d2a1acf015ab891eb5bb9ca0cdc8396";
    leaveDotGit = true;
    sha256 = "0z3i4aadyyklafm3lia8dg8l0wr3cvy53v3h7b533nm61lq07maf";
  };

  patches = [ ./fix-pythonpath.patch ];
})
