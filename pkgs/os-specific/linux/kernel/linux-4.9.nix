{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.169";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c6nz27q0m6nbb7v7kba6zrhzav5bqqllvwzzqf9cmd5cdn66xmp";
  };
} // (args.argsOverride or {}))
