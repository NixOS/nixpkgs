{ fetchurl }:
rec {
  version = "1.9.0";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "1jw99zwisq25l0smdm8f0gfwhynk532s2ch44blrvxyd7all8kcd";
  };

  srcs = [ src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "03x1pv8l4bv2fdns1l4sfy200nggy0a4b1f7qd0mnggdaj12c4jp";
    })];
}
