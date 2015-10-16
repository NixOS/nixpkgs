{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.3.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "112yprdy39cmhfgh6pfx34rlw9sp83fgzqixvgpq34akpykhad8c";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
