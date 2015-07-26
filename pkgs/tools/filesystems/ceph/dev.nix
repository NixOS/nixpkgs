{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.0.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    leaveDotGit = true;
    sha256 = "13iyv53kq2ka5py759cdiw0wmzpsycskvhmyr74qkpxmw9g6177y";
  };

  patches = [ ./fix-pythonpath.patch ];
})
