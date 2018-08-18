{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.149";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0v0w3f9jyhr34vcjivfwdxiz7gpl51532d7492ppzivmx1shqqf2";
  };
} // (args.argsOverride or {}))
