{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.2.0";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1lcal0jbpnm6y91s2v0g2zdnq7q0i5ql4bky294cz7g011di12vc";
  };

  patches = [ ./fix-pythonpath.patch ];
})
