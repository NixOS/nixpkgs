{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.197";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ypfl1q1bdbk81hk0bm8a0grqzz4z5rp7z7asa3191ji3r8q9x4w";
  };
} // (args.argsOverride or {}))
