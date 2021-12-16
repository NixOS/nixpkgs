{ fetchurl }:
rec {
  version = "1.8.8.1";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "sha256-58S+1wdbzWQC4/DC1bnb52rS7jxf1d3DlzozVsoj70Q=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "sha256-y17O3C4WS+o7SMayydbxw2v96R0GikxiqciF30j+jms=";
    })
  ];
}
