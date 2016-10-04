{ callPackage, fetchgit, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.2.0";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0a2v3bgkrbkzardcw7ymlhhyjlwi08qmcm7g34y2sjsxk9bd78an";
  };

  patches = [
    ./fix-pythonpath.patch
    # For building with xfsprogs 4.5.0:
    (fetchpatch {
      url = "https://github.com/ceph/ceph/commit/602425abd5cef741fc1b5d4d1dd70c68e153fc8d.patch";
      sha256 = "1iyf0ml2n50ki800vjich8lvzmcdviwqwkbs6cdj0vqv2nc5ii1g";
    })
  ];
})
