{ fetchurl }:
rec {
  version = "1.8.14";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-q1NpK5de3Y7tqIC0vDvADN3TT9DzFam0Y/Z5fSDGNFY=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-iKa+hnZUllDJCYfj8VEgF+Cqold0ctiARp4p0LqBQlU=";
    })
  ];
}
