{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    leaveDotGit = true;
    sha256 = "094f9knxgx8vb9fb1yzld9ib4m0wpqwqgqjl3xqf0dzm48nxqd73";
  };

  patches = [
    ./fix-pgrefdebugging.patch
    ./boost-158.patch
  ];
})
