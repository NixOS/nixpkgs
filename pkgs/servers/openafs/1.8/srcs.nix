{ fetchurl }:
rec {
  version = "1.8.8";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "sha256-2qjvhqdyf6z83jvJemrRQxKcHCXuNfM0cIDsfp0oTaA=";
  };

  srcs = [ src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "sha256-3cxODH1KvOTxrGB+acEudxGCX1iBPjZcTfjpfraOm+U=";
    })];
}
