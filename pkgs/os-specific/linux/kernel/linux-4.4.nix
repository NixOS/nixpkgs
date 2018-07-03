{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.139";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0igdsv9ihblmxfsgj646xac5n2bdawmwsr9hwyz6yjld43a5aq5n";
  };
} // (args.argsOverride or {}))
