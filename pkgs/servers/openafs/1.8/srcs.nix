{ fetchurl }:
rec {
  version = "1.8.9pre1";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/candidate/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "sha256-O51fZGse/SSuGLpr5FSQuwG0VHclYh+zNTefV1TGy3o=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/candidate/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "sha256-9ldv29R5atzj96sRTJ40xMynF5JKsC5djy3Fvw+pPy4=";
    })
  ];
}
