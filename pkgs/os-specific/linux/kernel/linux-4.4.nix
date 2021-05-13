{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.268";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1srk08kaxq5jjlqx804cgjffhcsrdkv3idh8ipagl6v2w4kas5v8";
  };
} // (args.argsOverride or {}))
