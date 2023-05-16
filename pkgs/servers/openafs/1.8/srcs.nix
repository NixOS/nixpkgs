{ fetchurl }:
rec {
<<<<<<< HEAD
  version = "1.8.10";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-n+wRNkYjVJ6NtzdAcvXI8BuEH2v+foVnPLzjX/Q/+wc=";
=======
  version = "1.8.9";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-0SYXi+H0LMoYy3wMJpGsNUUY43kBcBUKdrvSX00VHwY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
<<<<<<< HEAD
      hash = "sha256-nDgJ6K/qAX2K8lKPYM8OD5+oRU+shlM6PmciHy61+10=";
=======
      hash = "sha256-75HoVOq0qnQmhSWVSkHCoq0KLq9TDqoiu55L9FOxWTk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];
}
