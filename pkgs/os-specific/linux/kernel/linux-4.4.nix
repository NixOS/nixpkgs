{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.140";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1fy7hq438sqxcdgac5dw71qbb9g38z7bdqjyl79a1b0cvqy8yk0q";
  };
} // (args.argsOverride or {}))
