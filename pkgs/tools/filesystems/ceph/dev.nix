{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.0.2";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0kydjyvb1566mh33p6dlljfx1r4cfdj8ic4i19h5r9vavkc46nf0";
  };

  patches = [ ./fix-pythonpath.patch ];
})
