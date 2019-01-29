{ fetchurl }:
rec {
  version = "1.6.23";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "1gy7a0jhagxif8av540xb1aa6cl7id08nsgjbgady54bnmb0viga";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "18my71s9mddy0k835852ksjzkza7xs73kyxavmdqflh5vkywb6y0";
    })];
}
