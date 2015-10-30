{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-10-16";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "63d868106efd4d8aef71d498ba84cb2271a95a07";
    sha256 = "1sx0j50zp0is34x7rpddiizspg2qfscyfwc5yrw3y6hiklpzhz96";
  };

  patches = [ ./fix-pythonpath.patch ];
})
