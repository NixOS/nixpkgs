{ fetchurl }:
rec {
  version = "1.8.6";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "0i99klrw00v4bwd942n90xqfn16z6337m89xfm9dgv7ih0qrsklb";
  };

  srcs = [ src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "1s91kmxfimhdqrz7l6jgjz72j9pyalghrvg4h384fsz0ks6s4kz3";
    })];
}
