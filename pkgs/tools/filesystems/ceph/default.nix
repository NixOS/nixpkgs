{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.2.0";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0a2v3bgkrbkzardcw7ymlhhyjlwi08qmcm7g34y2sjsxk9bd78an";
  };

  patches = [ ./fix-pythonpath.patch ];
})
