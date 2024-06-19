{ fetchurl }:
rec {
  version = "1.8.11";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-4u+0cQmWt9IxmLU8Vilaj54k6KVVMXxfxjuBJaNxTs0=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-OsarP52T1V3hd1eQOwST/JAg8eBALqMZ5hIIs5ALYHw=";
    })
  ];
}
