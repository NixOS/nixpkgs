{ callPackage, fetchFromGitHub, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "9.2.0";

  src = fetchFromGitHub {
    owner = "ceph";
    repo = "ceph";
    rev = "refs/tags/v${version}";
    sha256 = "07isr1qs43hfc8mq2ashdvkc8b1w0pxwqlk8rjgxsf8w8687f4pf";
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
