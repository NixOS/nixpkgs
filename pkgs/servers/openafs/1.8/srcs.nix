{ fetchurl }:
rec {
  version = "1.8.2";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "13hksffp7k5f89c9lc5g5b1q0pc9h7wyarq3sjyjqam7c513xz95";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "09n8nymrhpyb0fhahpln2spzhy9pn48hvry35ccqif2jd4wsxdmr";
    })];
}
