{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.129";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "064kwdsxzk65mn991cmxqs31i332szf2z3lw5lgbzhgyzk9i0mbg";
  };
} // (args.argsOverride or {}))
