{ fetchurl }:
rec {
  version = "1.8.7";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "0ygsrf65w9sqji2x3jbx3h31vk6513s6nalzxi7p2ryf3xb3lm2k";
  };

  srcs = [ src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "0zri99pxmp4klh8ki5ycnjpf1h21lynn4049s6ywmap1vkpq84yn";
    })];
}
