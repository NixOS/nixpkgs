{ fetchurl }:
rec {
  version = "1.8.13.2";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-WatPYMuSXFd5yT4jNiEYbBIm1HcCOfsrVElC1Jzr2XY=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-s8DVtbro3UIYmcoQDRpq4lhluAFiEsdFfg/J95GxU+Q=";
    })
  ];
}
