{ fetchurl }:
rec {
  version = "1.8.10";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-n+wRNkYjVJ6NtzdAcvXI8BuEH2v+foVnPLzjX/Q/+wc=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-nDgJ6K/qAX2K8lKPYM8OD5+oRU+shlM6PmciHy61+10=";
    })
  ];
}
