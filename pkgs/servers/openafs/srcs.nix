{ fetchurl }:
rec {
  version = "1.6.22.2";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "15j17igignsfzv5jb47ryczsrz3zsmiqwnj38dx9gzz95807rkyf";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "1lpydca95nx5pmqvplb9n3akmxbzvhhypswh0s589ywxpv3zynxm";
    })];
}
