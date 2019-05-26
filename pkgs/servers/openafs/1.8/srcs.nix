{ fetchurl }:
rec {
  version = "1.8.3";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "19ffchxwgqg4wl98l456jdpgq2w8b5izn8hxdsq9hjs0a1nc3nga";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "14smdhn1f6f3cbvvwxgjjld0m4b17vqh3rzkxf5apmjsdda21njq";
    })];
}
