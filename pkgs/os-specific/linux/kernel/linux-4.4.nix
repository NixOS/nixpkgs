{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.243";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1daqbmj9ka9wdkkym625hqwqaxq5n11y7c4yc9ln3xkjpnv4dplm";
  };
} // (args.argsOverride or {}))
