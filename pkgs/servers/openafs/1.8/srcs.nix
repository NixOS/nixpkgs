{ fetchurl }:
rec {
  version = "1.8.9";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-0SYXi+H0LMoYy3wMJpGsNUUY43kBcBUKdrvSX00VHwY=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-75HoVOq0qnQmhSWVSkHCoq0KLq9TDqoiu55L9FOxWTk=";
    })
  ];
}
