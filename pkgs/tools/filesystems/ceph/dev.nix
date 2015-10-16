{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.1.0";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1f8z0dxl945370ifz2ila9bc55d81h41bmdq241y9z4pvaynl6pz";
  };

  patches = [ ./fix-pythonpath.patch ];
})
