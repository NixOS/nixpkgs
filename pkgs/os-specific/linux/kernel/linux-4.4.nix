{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.117";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0s2d5vaa8wzfsamf9wkafk6nv46q7809j7x6a394sy39jq7lj3qj";
  };
} // (args.argsOverride or {}))
