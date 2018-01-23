{ fetchurl }:
rec {
  version = "1.6.22.1";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "19nfbksw7b34jc3mxjk7cbz26zg9k5myhzpv2jf0fnmznr47jqaw";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "1875hn8rvlxj4icja8k6hprxprvp2k1f3iilb15lsafhmfz1scg3";
    })];
}
