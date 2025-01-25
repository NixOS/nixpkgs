{ fetchurl }:
rec {
  version = "1.8.13.1";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-eVc9fu/RzGUODFSd1oeiObxrGn7iys82KxoqOz9G/To=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-JwGqr0g1tanct8VISVOggiH63BOfrAVQ2kIukG5Xtcs=";
    })
  ];
}
