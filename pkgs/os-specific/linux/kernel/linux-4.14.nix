{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.47";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "06c8kl9f0s5qmqh9l16y1q7r44ld56kd0a00722c3aivddm3nav7";
  };
} // (args.argsOverride or {}))
