{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.3";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "020khb9978wayi4jnx7f9g1fzfg3r2xn9qw66snpd3k8w2dmycxy";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
