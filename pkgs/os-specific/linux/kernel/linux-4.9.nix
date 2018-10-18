{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.134";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0xvsk5q4w4sa3vk0rhckxn7faj12rvmfpwn08m4qf7024b8yiyvd";
  };
} // (args.argsOverride or {}))
