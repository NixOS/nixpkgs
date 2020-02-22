{ fetchurl }:
rec {
  version = "1.8.5";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "08w5n803xm75j7daa3mr2ncfmcg0wpm7yasj6zyddqlb4f7xdppf";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "08mg3n0q2igfas1khj18r9apyrkpbp1jick0ix5nfaal90jbifis";
    })];
}
