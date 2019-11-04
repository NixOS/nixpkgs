{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.198";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1b05jra6q695s1d4rzdr39i6m8xsi5xjrdn73sgwzvx0dgxfnwlm";
  };
} // (args.argsOverride or {}))
