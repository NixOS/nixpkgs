{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.86";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "11bf1jcxn5gwd1g99ml2kn65vkpciq8hdz7xc0bjy66gxysnxkx7";
  };
} // (args.argsOverride or {}))
