{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.136";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1j1f4v3m0gggarz0r33pk907gf8dy633s9x5k3ww3khkvzi335fk";
  };
} // (args.argsOverride or {}))
