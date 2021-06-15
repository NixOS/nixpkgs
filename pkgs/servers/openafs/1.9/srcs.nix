{ fetchurl }:
rec {
  version = "1.9.1";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "sha256-7rHihVR4VobHAzt0ZALFOLJnlfd1Qwsa5ohpRFWBPbw=";
  };

  srcs = [ src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "sha256-pvF8CdTl+5DNuymNvhb3UrGW05LcXRv8cZp2QQlXF+E=";
    })];
}
