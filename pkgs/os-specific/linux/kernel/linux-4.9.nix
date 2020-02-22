{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.214";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10z4n792g88p46csla2g9b0m7vz40ln0901ffb2cfd3hmhyhjzxl";
  };
} // (args.argsOverride or {}))
