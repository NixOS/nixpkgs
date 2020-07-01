{ fetchurl }:
rec {
  version = "1.6.24";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "1dxzc1y5mmx3ap0m94sx80vfs3qxkckid3wc1xm0wr5i6fh7zn1h";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "0aq9ipqpr2ksmk30h2dc4mlrkrqs16xnmspwfb6xj3rgr1pwszlx";
    })];
}
