{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.262";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0yz9qi4i46ndshxmb99kvv7lk6cbb09y7bzagq7sgvqaj4lwaw6j";
  };
} // (args.argsOverride or {}))
