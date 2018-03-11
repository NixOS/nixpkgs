{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libre ? false, ... } @ args:

buildLinux (args // rec {
  version = "4.9.87" + (if libre then "-gnu" else "");
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = if !libre
          then "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz"
          else "https://www.linux-libre.fsfla.org/pub/linux-libre/releases/${version}/linux-libre-${version}.tar.xz";
    sha256 = if !libre
             then "05y9wjmshd3pr3ymfpx80hjv5973i6l3zk1mpww7wnnwd6pzdjbs"
             else "1p8phvmxp04npzqzqcfmv8k9l5l65s7vpjcakdm0fxfkzvnswsp6";
  };
} // (args.argsOverride or {}))
