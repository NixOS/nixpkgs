{ fetchurl }:
rec {
  version = "1.8.12";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-EP6mgQxsCwD/ss0/OO1zLBfP15VcoJVNwkoqYXKibnU=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-ZMbDE8c9S7fHclRQo+bcSiXuHBtxt3IoSABOvOWWJWc=";
    })
  ];
}
