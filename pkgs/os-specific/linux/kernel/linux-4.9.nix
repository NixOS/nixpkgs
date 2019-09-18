{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.193";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00gx2sg0zc1xz6gs1kdkkd35gn7kjq1bjp1ydc774szsq0f0ircv";
  };
} // (args.argsOverride or {}))
