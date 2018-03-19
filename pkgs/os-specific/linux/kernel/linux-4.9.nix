{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.87";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "05y9wjmshd3pr3ymfpx80hjv5973i6l3zk1mpww7wnnwd6pzdjbs";
  };
} // (args.argsOverride or {}))
